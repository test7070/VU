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
			var custtypeItem = '';
			var xuccItem ='';
			$(document).ready(function() {
				_q_boxClose();
				q_getId();
				q_gt('custtype', '', 0, 0, 0, "");
				
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
                    fileName : 'z_vcc_vu2',
                    options : [{/* [1]*/
                        type : '0',
                        name : 'accy',
                        value : q_getId()[4]
                    }, {/* [2]*/
                        type : '0',
                        name : 'xname',
                        value : r_name 
                    },{
						type : '0',//[3]
						name : 'projectname',
						value : q_getPara('sys.project').toUpperCase()
					}, {
                        type : '0', //[4]
                        name : 'mountprecision',
                        value : q_getPara('vcc.mountPrecision')
                    }, {
                        type : '0', //[5]
                        name : 'weightprecision',
                        value : q_getPara('vcc.weightPrecision')
                    }, {
                        type : '0', //[6]
                        name : 'priceprecision',
                        value : q_getPara('vcc.pricePrecision')
                    }, {/*1-1 [7][8]*/
                        type : '1',
                        name : 'date'
                    }, {/*1-2[9][10]*/
                        type : '2',
                        name : 'xcust',
                        dbf  : 'cust',
                        index: 'noa,comp',
                        src  : 'cust_b.aspx'
                    }, {/*1-3 [11]*/
                        type : '8',
                        name : 'xoption01',
                        value : q_getMsg('toption01').split('&')
                    }, {/*1-4[12]*/
                        type : '5',
                        name : 'xproduct',
                        value : xuccItem.split(',')
                    }, {/*2-1[13]*/
                        type : '5', 
                        name : 'custtype',
                        value : custtypeItem.split(',')
					}, {/*2-2[14]*/
						type : '6',
						name : 'lostday'
					}, {/*2-3[15]*/
                        type : '5', 
                        name : 'lostorder',
                        value : "0@最後交易日,1@客戶編號".split(',')
					}, {/*2-4[16]*/
                        type : '5',
                        name : 'xuccgroupano',
                        value : uccgaItem.split(',')
					}, {/*3-1[17]*/
                        type : '6',
                        name : 'xsalesgroupano'
					}, {/*3-2 [18]*/
                        type : '6',
                        name : 'xenddate'
                    }]
                });
                q_popAssign();
				q_getFormat();
				q_langShow();

				$('#txtDate1').mask(r_picd);
                $('#txtDate2').mask(r_picd);
                $('#txtXenddate').mask(r_picd);
                $('#txtDate1').datepicker({dateFormat : 'yy/mm/dd'});
                $('#txtXenddate').datepicker({dateFormat : 'yy/mm/dd'});
                $('#Xproduct select').val('鋼筋');
                $('#txtLostday').val(100);
                $('#txtXenddate').val(q_date());
				
				$('#txtDate1').val(q_date().substr(0,r_len)+'/01/01');
				$('#txtDate2').val(q_date());
				
			}

			function q_boxClose(s2) {
			}

			function q_gtPost(t_name) {
				switch (t_name) {
					
					case 'custtype':
                        var as = _q_appendData("custtype", "", true);
                        custtypeItem = " @全部";
                        for ( i = 0; i < as.length; i++) {
                            custtypeItem = custtypeItem + (custtypeItem.length > 0 ? ',' : '') + as[i].noa + '@' + as[i].noa +' . '+as[i].namea;
                        }
                        q_gt('uccga', '', 0, 0, 0, ""); 
						break;
					case 'uccga':
                        var as = _q_appendData("uccga", "", true);
						uccgaItem = " @全部";
                        for ( i = 0; i < as.length; i++) {
                            uccgaItem = uccgaItem + (uccgaItem.length > 0 ? ',' : '') + as[i].noa + '@' + as[i].noa +' . '+as[i].namea;
                        }
                        q_gt('ucc', '1=1 ', 0, 0, 0, "ucc"); 					
                        break;	
					case 'ucc':
						xuccItem = " @全部";
                		var as = _q_appendData("ucc", "", true);
						for ( i = 0; i < as.length; i++) {
							xuccItem+=","+as[i].product;
						}
						q_gf('', 'z_vcc_vu2');
						break;  
				}
			}
		</script>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	>
		<div id="q_menu"></div>
		<div style="position: absolute;top: 10px;left:50px;z-index: 1;width:2000px;">
			<div id="container">
				<div id="q_report"></div>
			</div>
			<div class="prt" style="margin-left: -40px;">
                <!--#include file="../inc/print_ctrl.inc"-->
            </div>
		</div>
	</body>
</html>

