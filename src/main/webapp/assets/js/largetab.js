
function FixTable(TableClass, FixColumnNumber, width, height) {

    if ($("." + TableClass + "_tableLayout").length != 0) {
        $("." + TableClass + "_tableLayout").before($("." + TableClass));
        $("." + TableClass + "_tableLayout").empty();
        $("." + TableClass + "_tableLayout").css({"height":height})
    }else {
        $("." + TableClass).after("<div class='" + TableClass + "_tableLayout' style='overflow:;height:" + height + "px; width:100%;'></div>");
    }

 
    $('<div class="' + TableClass + '_tableFix"></div>'
    + '<div class="' + TableClass + '_tableHead"></div>'
    + '<div class="' + TableClass + '_tableColumn"></div>'
    + '<div class="' + TableClass + '_tableData"></div>').appendTo("." + TableClass + "_tableLayout");
 
 
    var oldtable = $("." + TableClass);
 
    var tableFixClone = oldtable.clone(true);
    tableFixClone.attr("id", TableClass + "_tableFixClone");
    $("." + TableClass + "_tableFix").append(tableFixClone);
    var tableHeadClone = oldtable.clone(true);
    tableHeadClone.attr("id", TableClass + "_tableHeadClone");
    $("." + TableClass + "_tableHead").append(tableHeadClone);
    var tableColumnClone = oldtable.clone(true);
    tableColumnClone.attr("id", TableClass + "_tableColumnClone");
    $("." + TableClass + "_tableColumn").append(tableColumnClone);
    $("." + TableClass + "_tableData").append(oldtable);
 
    $("." + TableClass + "_tableLayout table").each(function () {
        $(this).css("margin", "0");
    });
 
 
    var HeadHeight = $("." + TableClass + "_tableHead thead").height();
    HeadHeight += 2;
    $("." + TableClass + "_tableHead").css("height", HeadHeight);
    $("." + TableClass + "_tableFix").css("height", HeadHeight);
 
 
    var ColumnsWidth = 0;
    var ColumnsNumber = 0;
    $("." + TableClass + "_tableColumn tr:last td:lt(" + FixColumnNumber + ")").each(function () {
        ColumnsWidth += $(this).outerWidth(true);
        ColumnsNumber++;
    });
    ColumnsWidth += 2;

    $("." + TableClass + "_tableColumn").css("width", ColumnsWidth);
    $("." + TableClass + "_tableFix").css("width", ColumnsWidth);
 
 
    $("." + TableClass + "_tableData").scroll(function () {
        $("." + TableClass + "_tableHead").scrollLeft($("." + TableClass + "_tableData").scrollLeft());
        $("." + TableClass + "_tableColumn").scrollTop($("." + TableClass + "_tableData").scrollTop());
    });
 
//  var pWidth=$("." + TableClass + "_tableLayout").width();
//	var sWidth=pWidth-17
//	$("."+TableClass+"_tableLayout").css("width",sWidth);
	
    $("." + TableClass + "_tableFix").css({ "overflow": "hidden", "position": "relative", "z-index": "50", "background-color": "#fff" });
    $("." + TableClass + "_tableHead").css({ "overflow": "hidden", "width": width - 17, "position": "relative", "z-index": "45", "background-color": "#fff" });
    $("." + TableClass + "_tableColumn").css({ "overflow": "hidden", "height": height - 17, "position": "relative", "z-index": "40", "background-color": "#fff" });
    $("." + TableClass + "_tableData").css({ "overflow": "auto", "width": width, "height": height, "position": "relative", "z-index": "35" });
 
    if ($("." + TableClass + "_tableHead").width() > $("." + TableClass + "_tableFix table").width()) {
        $("." + TableClass + "_tableHead").css("width", $("." + TableClass + "_tableFix table").width());
        $("." + TableClass + "_tableData").css("width", $("." + TableClass + "_tableFix table").width() + 17);
    }
    if ($("." + TableClass + "_tableColumn").height() > $("." + TableClass + "_tableColumn table").height()) {
        $("." + TableClass + "_tableColumn").css("height", $("." + TableClass + "_tableColumn table").height());
        $("." + TableClass + "_tableData").css("height", $("." + TableClass + "_tableColumn table").height() + 18);
    }
 
    $("." + TableClass + "_tableFix").offset($("." + TableClass + "_tableLayout").offset());
    $("." + TableClass + "_tableHead").offset($("." + TableClass + "_tableLayout").offset());
    $("." + TableClass + "_tableColumn").offset($("." + TableClass + "_tableLayout").offset());
    $("." + TableClass + "_tableData").offset($("." + TableClass + "_tableLayout").offset());
    
}

