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
            aPop = new Array(['txtXcno', '', 'acomp', 'noa,acomp,nick', 'txtXcno', "acomp_b.aspx"], ['txtXpart', '', 'part', 'part,noa', 'txtXpart', "part_b.aspx"]);
            if (location.href.indexOf('?') < 0) {
                location.href = location.href + "?;;;;" + ((new Date()).getUTCFullYear() - 1911);
            }
            $(document).ready(function() {
                q_getId();
                q_gf('', 'z_pay_vu');
                
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
                    fileName : 'z_pay_vu',
                    options : [{
                        type : '0', //[1]
                        name : 'xaccy',
                        value : r_accy
                    },{
                        type : '0', //[2]
                        name : 'accy',
                        value : r_accy + "_" + r_cno
                    }, {
                        type : '0', //[3]
                        name : 'rc2taxtype',
                        value : q_getPara('rc2.d4taxtype')
                    },{
                        type : '0', //[4]
                        name : 'xproject',
                        value : q_getPara('sys.project').toUpperCase()
                    }, {
                        type : '6', //[5]
                        name : 'xcno'
                    }, {
                        type : '1', //[6][7]
                        name : 'xdate'
                    }, {
                        type : '2', //[8][9]
                        name : 'xtgg',
                        dbf : 'tgg',
                        index : 'noa,comp',
                        src : 'tgg_b.aspx'
                    }, {
                        type : '1', //[10][11]
                        name : 'xmon'
                    },{
                        type : '2', //[12][13]
                        name : 'xcardeal',
                        dbf : 'cardeal',
                        index : 'noa,comp',
                        src : 'cardeal_b.aspx'
                    }, {
                        type : '2', //[14][15]
                        name : 'xsales',
                        dbf : 'sss',
                        index : 'noa,namea',
                        src : 'sss_b.aspx'
                    },  {
                        type : '8',//[16]
                        name : 'xoption01',
                        value : 'detail@明細'.split('&')
                    }]
                });
                q_popAssign();
				q_getFormat();
				q_langShow();
				
                $('#txtXdate1').mask(r_picd);
                $('#txtXdate2').mask(r_picd);
                $('#txtXdate1').datepicker({dateFormat : 'yy/mm/dd'});
                $('#txtXdate2').datepicker({dateFormat : 'yy/mm/dd'});
                $('#txtXmon1').mask(r_picm);
                $('#txtXmon2').mask(r_picm);
                
                var t_date, t_year, t_month, t_day;
                t_date = new Date();
                t_date.setDate(1);
                t_year = t_date.getUTCFullYear();
                t_month = t_date.getUTCMonth() + 1;
                t_month = t_month > 9 ? t_month + '' : '0' + t_month;
                t_day = t_date.getUTCDate();
                t_day = t_day > 9 ? t_day + '' : '0' + t_day;
                $('#txtXdate1').val(t_year + '/' + t_month + '/' + t_day);
                $('#txtXmon1').val(t_year + '/' + t_month);
                $('#txtXmon2').val(t_year + '/' + t_month);
                
                t_date = new Date();
                t_date.setDate(35);
                t_date.setDate(0);
                t_year = t_date.getUTCFullYear();
                t_month = t_date.getUTCMonth() + 1;
                t_month = t_month > 9 ? t_month + '' : '0' + t_month;
                t_day = t_date.getUTCDate();
                t_day = t_day > 9 ? t_day + '' : '0' + t_day;
                $('#txtXdate2').val(t_year + '/' + t_month + '/' + t_day);
                
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
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
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
