import 'package:flutter/material.dart';
import 'package:rmc_customer/adapter/item_book_ambulance.dart';

import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class BookAmbulance extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BookAmbulancePage();
  }
}

class BookAmbulancePage extends State<BookAmbulance> {
  late BuildContext ctx;
  bool isLoaded = false;
  String? sID;

  List<dynamic> resultList = [];
  List<dynamic> filterList = [];

  @override
  void initState() {
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getData();
      }
    });
    super.initState();
  }

  //Api Method
  getData() async {
    //Output
    var result = await STM().get(ctx, Str().loading, "get_ambulances");
    if (!mounted) return;
    setState(() {
      isLoaded = true;
      resultList = result['ambulances'];
      filterList = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Clr().screenBackground,
      appBar: titleToolbarLayout(ctx, 'Book Ambulance'),
      body: Visibility(
        visible: isLoaded,
        child: bodyLayout(),
      ),
    );
  }

  //Body
  Widget bodyLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        Dim().pp,
      ),
      child: Column(
        children: [
          TextFormField(
            // controller: nameCtrl,
            cursorColor: Clr().primaryColor,
            style: Sty().mediumText,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            decoration: Sty().textFieldWhiteStyle.copyWith(
                  hintStyle: Sty().mediumText.copyWith(
                        color: Clr().lightGrey,
                      ),
                  hintText: "Search Ambulance",
                  prefixIcon: Icon(
                    Icons.search,
                    color: Clr().grey,
                  ),
                ),
            onChanged: (v) {
              setState(() {
                filterList = resultList
                    .where((e) => e['provider']
                        .trim()
                        .toLowerCase()
                        .contains(v.trim().toLowerCase()))
                    .toList();
              });
            },
          ),
          SizedBox(
            height: Dim().d12,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Providers",
                  style: Sty().mediumBoldText,
                ),
              ),
              Text(
                "Contact",
                style: Sty().mediumBoldText,
              ),
              SizedBox(
                width: Dim().d32,
              ),
            ],
          ),
          SizedBox(
            height: Dim().d8,
          ),
          const Divider(),
          if (filterList.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filterList.length,
              itemBuilder: (context, index) {
                return itemBookAmbulance(ctx, filterList[index]);
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
          if (filterList.isEmpty)
            SizedBox(
                height: MediaQuery.of(ctx).size.height / 2,
                child: Center(child: STM().emptyData("No Ambulance Found")))
        ],
      ),
    );
  }
}
