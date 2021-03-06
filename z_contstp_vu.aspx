<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title></title>
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
			aPop = new Array(/*['txtCustno', 'lblCustno', 'tgg', 'tggno,comp', 'txtCustno', 'cust_b.aspx']
			/*,['txtXcarplateno', 'lblXcarplate', 'carplate', 'noa,carplate,driver', 'txtXcarplateno', 'carplate_b.aspx']
			,['txtXproductno', 'lblXproductno', 'fixucc', 'noa,namea', 'txtXproductno', 'fixucc_b.aspx']*/);
			$(document).ready(function() {
				_q_boxClose();
				q_getId();
				q_gf('', 'z_contstp_vu');
				
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
                    fileName : 'z_contstp_vu',
                    options : [{/* [1]*/
                        type : '0',
                        name : 'accy',
                        value : q_getId()[4]
                    }, {/* [2]*/
                        type : '0',
                        name : 'xname',
                        value : r_name 
                    }, {/*1-1[3][4]*/
                        type : '2',
                        name : 'tgg',
                        dbf  : 'tgg',
                        index: 'noa,comp',
                        src  : 'tgg_b.aspx'
                    }, {/*1-2 [5][6]*/
                        type : '1',
                        name : 'date'
                    }, {/*1-3 [7]*/
                        type : '8',
                        name : 'xoption01',
                        value : q_getMsg('toption01').split('&')
                    },{
						type : '0',//[8]
						name : 'projectname',
						value : q_getPara('sys.project').toUpperCase()
					}, {
                        type : '0', //[9]
                        name : 'mountprecision',
                        value : q_getPara('rc2.mountPrecision')
                    }, {
                        type : '0', //[10]
                        name : 'weightprecision',
                        value : q_getPara('rc2.weightPrecision')
                    }, {
                        type : '0', //[11]
                        name : 'priceprecision',
                        value : q_getPara('rc2.pricePrecision')
                    }]
                });
                q_popAssign();
				q_getFormat();
				q_langShow();

				$('#txtDate1').mask(r_picd);
                $('#txtDate2').mask(r_picd);
                $('#txtDate1').datepicker({dateFormat : 'yy/mm/dd'});
                $('#txtDate2').datepicker({dateFormat : 'yy/mm/dd'});
                
				var t_date, t_year, t_month, t_day;
				t_date = new Date();
				if(q_getPara('sys.project').toUpperCase()=='SF' || q_getPara('sys.project').toUpperCase()=='VU'){
					t_date.setFullYear(t_date.getFullYear()-2);
					t_date.setMonth(0);
				}else{
					t_date.setFullYear(t_date.getFullYear()-1);
				}
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

			function q_gtPost(s2) {
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

