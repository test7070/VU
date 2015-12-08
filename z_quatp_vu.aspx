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
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"></script>
		<script type="text/javascript">
			var custtypeItem = '';
			var xuccItem ='';
			$(document).ready(function() {
				_q_boxClose();
				q_getId();
				q_gt('custtype', '', 0, 0, 0, "");
			});  
			
            function q_gfPost() {
                $('#q_report').q_report({
                    fileName : 'z_quatp_vu',
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
					}]
                });
                q_popAssign();
				q_getFormat();
				q_langShow();

				$('#txtDate1').mask(r_picd);
                $('#txtDate2').mask(r_picd);
                $('#Xproduct select').val('鋼筋');
                $('#txtLostday').val(100);
                
				var t_date, t_year, t_month, t_day;
				t_date = new Date();
				t_date.setMonth(-14);
				t_date.setDate(1);
				t_year = t_date.getUTCFullYear();
				t_month = t_date.getUTCMonth() + 1;
				t_month = t_month > 9 ? t_month + '' : '0' + t_month;
				t_day = t_date.getUTCDate();
				t_day = t_day > 9 ? t_day + '' : '0' + t_day;
				$('#txtDate1').val(t_year + '/' + t_month + '/' + t_day);

				t_date = new Date();
				t_date.setDate(35);
				t_date.setDate(0);
				t_year = t_date.getUTCFullYear();
				t_month = t_date.getUTCMonth() + 1;
				t_month = t_month > 9 ? t_month + '' : '0' + t_month;
				t_day = t_date.getUTCDate();
				t_day = t_day > 9 ? t_day + '' : '0' + t_day;
				$('#txtDate2').val(t_year + '/' + t_month + '/' + t_day );
				
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
                        q_gt('ucc', '1=1 ', 0, 0, 0, "ucc"); 
						break;
					case 'ucc':
						xuccItem = " @全部";
                		var as = _q_appendData("ucc", "", true);
						for ( i = 0; i < as.length; i++) {
							xuccItem+=","+as[i].product;
						}
						q_gf('', 'z_quatp_vu');
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

