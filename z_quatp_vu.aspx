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
				
				q_gf('', 'z_quatp_vu');
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
                    }, {/*1-2 [9]*/
                        type : '8',
                        name : 'xoption02',
                        value : q_getMsg('toption02').split('&')
                    }, {/*1-3[10][11]*/
                        type : '2',
                        name : 'xcust',
                        dbf  : 'cust',
                        index: 'noa,comp',
                        src  : 'cust_b.aspx'
                    }, {/*1-4 [12]*/
                        type : '8',
                        name : 'xoption01',
                        value : q_getMsg('toption01').split('&')
                    }, {/*2-1 [13]*/
                        type : '6',
                        name : 'xaddr2'
                    }, {/*2-2 [14]*/
                        type : '5',//篩選完工未完工//
						name : 'xpost2',
						value : [' @全部','通案','慶欣欣專案','威致專案','工地']
                    }, {/*2-3 [15] SF用*/
                        type : '5',//排序
						name : 'xorder',
						value : ['custno@客戶編號','edate@完工日']
                    }, {/*2-4 [16] SF用*/
                        type : '8',
						name : 'xoption012',
						value : ['sel2@含合約終止']
                    }]
                });
                q_popAssign();
				q_getFormat();
				q_langShow();
				
				if(r_len==4){                	
                	$.datepicker.r_len=4;
					//$.datepicker.setDefaults($.datepicker.regional["ENG"]);
                }

				$('#txtDate1').mask(r_picd);
                $('#txtDate2').mask(r_picd);
                
				var t_date, t_year, t_month, t_day;
				t_date = new Date();
				t_date.setMonth(-6);
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
				
				$('#Date').css('width','300px');
				$('#Date .c3').css('width','90px');
				$('#Xoption02').css('width','300px').css('height','30px');
				$('#chkXoption02').css('width','200px').css('margin-top','5px');
				$('#chkXoption02 span').css('width','150px');
				$('#chkXoption02 input').prop('checked',true);
				$('#Xpost2 .label').css('width','150px');
				
				
				if(q_getPara('sys.project').toUpperCase()!='SF'){
					var t_index=-1;
					for(var i=0;i<$('#q_report').data().info.reportData.length;i++){
						if($('#q_report').data('info').reportData[i].report=='z_quatp_vu02'){
							t_index=i;
							break;	
						}
					}
					if(t_index>-1){
						$('#q_report div div').eq(i).hide();
					}
				}
				$('#Xoption012').css('width','300px').css('height','30px');
				$('#chkXoption012').css('width','200px').css('margin-top','5px');
				$('#chkXoption012 span').css('width','150px');
			}

			function q_boxClose(s2) {
			}

			function q_gtPost(t_name) {
				switch (t_name) {
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

