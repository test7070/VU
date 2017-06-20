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
            var uccgaItem = '';
            $(document).ready(function() {
                _q_boxClose();
                q_getId();
                q_gf('', 'z_orde_vu');
                
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
                    fileName : 'z_orde_vu',
                    options : [
                    {  //[1][2]
                    	type : '1',
                        name : 'xdate'
                 	},{//[3][4]
                 		type : '1',
                 		name : 'xodate'
                 	},{//[5][6]
                 		type : '2', 
                        name : 'xcust',
                        dbf : 'cust',
                        index : 'noa,comp',
                        src : 'cust_b.aspx'
                 	}]
                });
                q_popAssign();
                q_getFormat();
                q_langShow();
                
                
 			 var r_1911=1911;
				if(r_len==4){//西元年
					r_1911=0;
					$('#txtXodate1').datepicker({dateFormat : 'yy/mm/dd'});
					$('#txtXodate2').datepicker({dateFormat : 'yy/mm/dd'});
					$('#txtXdate1').datepicker({dateFormat : 'yy/mm/dd'});
					$('#txtXdate2').datepicker({dateFormat : 'yy/mm/dd'});
				}else{
					$('#txtXodate1').datepicker();
					$('#txtXodate2').datepicker();
					$('#txtXdate1').datepicker();
					$('#txtXdate2').datepicker();
				}
                 
                 $('#txtXodate1').mask(r_picd);
	             $('#txtXodate2').mask(r_picd);
	             $('#txtXdate1').mask(r_picd);
	             $('#txtXdate2').mask(r_picd);
           
                
                 var t_date, t_year, t_month, t_day;
                t_date = new Date();
                t_date.setDate(1);
                t_year = t_date.getUTCFullYear() - r_1911;
                t_year = t_year > 99 ? t_year + '' : '0' + t_year;
                t_month = t_date.getUTCMonth() + 1;
                t_month = t_month > 9 ? t_month + '' : '0' + t_month;
                t_day = t_date.getUTCDate();
                t_day = t_day > 9 ? t_day + '' : '0' + t_day;
                $('#txtXodate1').val(t_year + '/' + t_month + '/' + '01');
				
				
				
                t_date = new Date();
                t_date.setDate(35);
                t_date.setDate(0);
                t_year = t_date.getUTCFullYear() - r_1911;
                t_year = t_year > 99 ? t_year + '' : '0' + t_year;
                t_month = t_date.getUTCMonth() + 1;
                t_month = t_month > 9 ? t_month + '' : '0' + t_month;
                t_day = t_date.getUTCDate();
                t_day = t_day > 9 ? t_day + '' : '0' + t_day;
                $('#txtXodate2').val(t_year + '/' + t_month + '/' + '30');
                

               
            }

            function q_popPost(s1) {
                switch (s1) {

                }
            }

            function q_boxClose(s2) {

            }
		
		</script>
		<style type="text/css">
            .num {
                text-align: right;
                padding-right: 2px;
            }
            #q_report select {
            	font-size: medium;
    			margin-top: 2px;
            }
            select {
            	font-size: medium;
            }
		</style>
	</head>
	<body id="z_accc" ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
		<div id="q_menu"></div>
		<div style="position: absolute;top: 10px;left:50px;z-index: 1;width:2000px;">
			<div id="container">
				<div id="q_report"></div>
				<!--<input type="button" id="btnUcf" value="成本結轉" style="font-weight: bold;font-size: medium;color: red;">-->
			</div>
			<div class="prt" style="margin-left: -40px;">
				<!--#include file="../inc/print_ctrl.inc"-->
			</div>
		</div>
	</body>
</html>