import 'dart:developer';
import 'dart:io';
import 'package:MauhurtikaAstrology/utils/global.dart' as global;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;

class PdfViewerPage extends StatefulWidget {
  final String url;
  const PdfViewerPage({super.key, required this.url});

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String downloadedUrlpdf = '';
  @override
  void initState() {
    super.initState();
    print("url is ${widget.url}");
    getFileName(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: _downloadPdf,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: downloadedUrlpdf != ""
          ? SfPdfViewer.network(
              downloadedUrlpdf,
              onDocumentLoadFailed: (details) {
                print('Document load failed: ${details.error}');
                print('Error description: ${details.description}');
              },
              onDocumentLoaded: (e) {
                // Document loaded successfully
              },
            )
          : Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }

  getFileName(String? pdfUrl) {
    if (pdfUrl != null) {
      var result = pdfUrl.substring(pdfUrl.lastIndexOf('/') + 1);
      if (result.contains('?')) {
        result = result.substring(0, result.lastIndexOf('?'));
      }
      getPdfDownloadUrl(result);
    }
  }

  getPdfDownloadUrl(String prefixurl) async {
    log('Download prefix: ${Uri.decodeFull(prefixurl)}');

    try {
      final storageRef =
          FirebaseStorage.instance.ref().child(Uri.decodeFull(prefixurl));
      final downloadURL = await storageRef.getDownloadURL();
      setState(() {
        log('Download URL: $downloadURL');
        downloadedUrlpdf = downloadURL;
      });
    } catch (e) {
      print('Error getting download URL: $e');
      return '';
    }
  }

  void _downloadPdf() async {
    try {
      final response = await http.get(Uri.parse(downloadedUrlpdf));
      final fileName =
          'downloaded_pdf_${DateTime.now().millisecondsSinceEpoch}.pdf';

      final storageStatus = await Permission.storage.status;
      if (!storageStatus.isGranted) {
        await Permission.storage.request();
      }

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final directory = Platform.isIOS
            ? await getApplicationDocumentsDirectory()
            : await getDownloadsDirectory();
        final filePath = '${directory!.path}/$fileName';
        log('save path is $filePath');

        await File(filePath).writeAsBytes(bytes);
        _initializeNotifications(filePath);

        // Show a notification after the PDF is downloaded
        showDownloadCompleteNotification();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF downloaded successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        global.showSnackBar('Error downloading PDF:', '${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading PDF: $e');
      global.showSnackBar('Error downloading PDF', '$e');
    }
  }

  void showDownloadCompleteNotification() async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel.id',
      'channel.name',
      importance: Importance.max,
      priority: Priority.high,
      icon: "@mipmap/ic_launcher",
      playSound: true,
    );
    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails();

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Download Complete',
      'Your PDF has been downloaded successfully!',
      platformChannelSpecifics,
    );
  }

  void _initializeNotifications(String locationpath) async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      defaultPresentBadge: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
      defaultPresentSound: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        return;
      },
    );
    final InitializationSettings initialSetting = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    flutterLocalNotificationsPlugin.initialize(initialSetting,
        onDidReceiveNotificationResponse: (_) {
      onSelectNotification(locationpath);
    });
  }

  void onSelectNotification(String filePath) {
    log('location to open is $filePath');
    OpenFile.open(filePath);
  }
}
