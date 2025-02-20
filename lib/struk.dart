import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pdfWidget;

class struk extends StatefulWidget {
  final Map penjualan;
  const struk({super.key, required this.penjualan});

  @override
  State<struk> createState() => _strukState();
}

class _strukState extends State<struk> {
  @override
  Widget build(BuildContext context) {
    var penjualan=widget.penjualan;
    List detail=penjualan["detailpenjualan"];
    return Scaffold(
      appBar: AppBar(leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back)), title: Text("Struk"),centerTitle: true,),
      body: PdfPreview(
          initialPageFormat: PdfPageFormat.a4,
          allowSharing: false,
          canChangeOrientation: false,
          canChangePageFormat: false,
          canDebug: false,
          build: (format) async {
            final titleFont = await PdfGoogleFonts.grechenFuemenRegular();
            final fontBold = await PdfGoogleFonts.ralewayBlack();
            final font = await PdfGoogleFonts.ralewayLight();
            var pdf = pdfWidget.Document();
            pdf.addPage(pdfWidget.Page(build: (context) {
              return pdfWidget.Column(
                  mainAxisAlignment: pdfWidget.MainAxisAlignment.spaceBetween,
                  children: [
                    pdfWidget.Row(
                        mainAxisAlignment: pdfWidget.MainAxisAlignment.center,
                        children: [
                          pdfWidget.Text("Louis Store",
                              style: pdfWidget.TextStyle(
                                  font: titleFont, fontSize: 50)),
                        ]),
                    pdfWidget.Container(
                        padding: pdfWidget.EdgeInsets.only(top: 20, bottom: 20),
                        child: pdfWidget.Column(
                            mainAxisAlignment:
                                pdfWidget.MainAxisAlignment.center,
                            children: [
                              pdfWidget.Row(children: [
                                pdfWidget.Text("Tanggal transaksi:",
                                    style: pdfWidget.TextStyle(
                                        font: font, fontSize: 25)),
                                pdfWidget.Spacer(),
                                pdfWidget.Text(
                                    "${penjualan["TanggalPenjualan"]}",
                                    style: pdfWidget.TextStyle(
                                        font: font, fontSize: 25)),
                              ]),
                              pdfWidget.SizedBox(height: 50),
                              ...List.generate(detail.length, (index) {
                                return pdfWidget.Row(children: [
                                  pdfWidget.Text(
                                      "${detail[index]["produk"]["NamaProduk"]} (${detail[index]["JumlahProduk"]})",
                                      style: pdfWidget.TextStyle(
                                          font: font, fontSize: 25)),
                                  pdfWidget.Spacer(),
                                  pdfWidget.Text(
                                      "Rp.${detail[index]["Subtotal"].toString()}",
                                      style: pdfWidget.TextStyle(
                                          font: font, fontSize: 25)),
                                ]);
                              }),
                              pdfWidget.SizedBox(height: 50),
                              pdfWidget.SizedBox(height: 50),
                              pdfWidget.Row(children: [
                                pdfWidget.Text("Total",
                                    style: pdfWidget.TextStyle(
                                        font: fontBold, fontSize: 25)),
                                pdfWidget.Spacer(),
                                pdfWidget.Text(
                                    "Rp.${penjualan["TotalHarga"].toString()}",
                                    style: pdfWidget.TextStyle(
                                        font: fontBold, fontSize: 25)),
                              ])
                            ])),
                    pdfWidget.Row(
                        mainAxisAlignment: pdfWidget.MainAxisAlignment.center,
                        children: [
                          pdfWidget.Text(
                              "SienceStore\nJl.Lolaras no.7, Malang, Jawa Timur",
                              textAlign: pdfWidget.TextAlign.center,
                              style:
                                  pdfWidget.TextStyle(font: font, fontSize: 15))
                        ])
                  ]);
            }));
            return pdf.save();
          }),
    );
  }
}