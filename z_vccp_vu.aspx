<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"></script>
		<script src="css/jquery/ui/jquery.ui.widget.js"></script>
		<script src="css/jquery/ui/jquery.ui.datepicker.js"></script>
		<script type="text/javascript">
            var vccgaItem = '';
            $(document).ready(function() {
                   _q_boxClose();
                q_getId();
                q_gt('spec', '1=1 ', 0, 0, 0, "spec");
                
                $.datepicker.regional['zh-TW']={
				   dayNames:["星期日","星期一","星期二","星期三","星期四","星期五","星期六"],
				   dayNamesMin:["日","一","二","三","四","五","六"],
				   monthNames:["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"],
				   monthNamesShort:["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"],
				   prevText:"上月",
				   nextText:"次月",
				   weekHeader:"週"
				};
				//將預設語系設定為中文
				$.datepicker.setDefaults($.datepicker.regional["zh-TW"]);
            });
            function q_gfPost() {
                $('#q_report').q_report({
                    fileName : 'z_vccp_vu',
                    options : [{
                        type : '0', //[1]
                        name : 'accy',
                        value : r_accy
                    }, {
                        type : '1', //[2][3]
                        name : 'xnoa'
                    }, {
                        type : '8', //[4]
                        name : 'xshowprice',
                        value : "1@".split(',')
                    }, {
                        type : '0', //[5] //判斷顯示小數點
                        name : 'xacomp',
                        value : q_getPara('sys.comp')
                    }, {
                        type : '2',
                        name : 'product', //[6][7]
                        dbf : 'ucaucc',
                        index : 'noa,product',
                        src : 'ucaucc_b.aspx'
                    }, {
                        type : '6',
                        name : 'xuno' //[8]
                    }, {
                        type : '6',
                        name : 'edate' //[9]
                    }, {
                        type : '6',
                        name : 'xspec' //[10]
                    }, {
                        type : '5',
                        name : 'xsize', //[11]
                        value:(',#2,#3,#4,#5,#6,#7,#8,#9,#10,#11,#12,#13,#14,#15,#16').split(',')
                    }, {
                        type : '1',
                        name : 'xlengthb' //[12][13]
                    }, {
                        type : '6',
                        name : 'xclass' //[14]
                    }, {
                        type : '2',
                        name : 'xcust', //[15][16]
                        dbf : 'cust',
                        index : 'noa,comp',
                        src : 'cust_b.aspx'
                    }, {
                        type : '1', //[17][18]
                        name : 'xordeno'
                    }]
                });
                q_popAssign();
                q_getFormat();
                q_langShow();

                var t_noa = typeof (q_getId()[3]) == 'undefined' ? '' : q_getId()[3];
                t_noa = t_noa.replace('noa=', '');
                $('#txtXnoa1').val(t_noa);
                $('#txtXnoa2').val(t_noa);

                $("input[type='checkbox'][value!='']").attr('checked', true);
                
                
                $('#txtEdate').mask(r_picd);
                $('#txtEdate').val(q_date());
                $('#txtEdate').datepicker({dateFormat : 'yy/mm/dd'});
                $("#Xlengthb").css('width', '302px');
                $("#Xlengthb input").css('width', '90px');

                $('#txtXsize').change(function() {
                    if ($('#txtXsize').val().substr(0, 1) != '#')
                        $('#txtXsize').val('#' + $('#txtXsize').val());
                });

                $('#txtXlengthb1').addClass('num').val(0).change(function() {
                    $(this).val(dec($(this).val()));
                    if ($(this).val() == 'NaN')
                    	$(this).val(0);
                });
                $('#txtXlengthb2').addClass('num').val(99).change(function() {
                    $(this).val(dec($(this).val()));
                    if ($(this).val() == 'NaN')
                    	$(this).val(99);
                });
                
                var tmp = document.getElementById("txtXspec");
                var selectbox = document.createElement("select");
                selectbox.id="combSpec";
                selectbox.style.cssText ="width:20px;font-size: medium;";
                tmp.parentNode.appendChild(selectbox,tmp);
                q_cmbParse("combSpec", t_spec); 
                 $('#combSpec').change(function() {
					$('#txtXspec').val($('#combSpec').find("option:selected").text());
				});
                
            }
            
            	var t_spec='@';
            function q_gtPost(t_name) {
                switch (t_name) {
                	case 'spec':
                		var as = _q_appendData("spec", "", true);
						for ( i = 0; i < as.length; i++) {
							t_spec+=","+as[i].noa;
						}
                		q_gf('', 'z_vccp_vu');
                		break;
                    default:
                        break;
                }
            }
   			function q_popPost(s1) {
                switch (s1) {

                }
            }

            function q_boxClose(s2) {

            }
		</script>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
		<div id="q_menu"> </div>
		<div style="position: absolute;top: 10px;left:50px;z-index: 1;width:2000px;">
			<div id="container">
				<div id="q_report"> </div>
			</div>
			<div class="prt" style="margin-left: -40px;">
				<!--#include file="../inc/print_ctrl.inc"-->
			</div>
		</div>
	</body>
</html>

