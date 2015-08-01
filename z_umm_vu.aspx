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
            if (location.href.indexOf('?') < 0) {
                location.href = location.href + "?;;;;" + ((new Date()).getUTCFullYear() - 1911);
            }
            t_isinit = false;
            $(document).ready(function() {
                q_getId();
                q_gf('', 'z_umm_vu');

                $('#q_report').click(function(e) {
                });
            });

            function q_gfPost() {
                $('#q_report').q_report({
                    fileName : 'z_umm_vu',
                    options : [{
                        type : '0', //[1]
                        name : 'accy',
                        value : r_accy
                    },{
                        type : '0',
                        name : 'caccy', //[2]
                        value : r_accy + "_" + r_cno
                    },{
                        type : '0', //[3] //判斷vcc是內含或應稅 內含不抓vcca
                        name : 'vcctax',
                        value : q_getPara('sys.d4taxtype')
                    },{
                        type : '0', //[4]
                        name : 'xproject',
                        value : q_getPara('sys.project').toUpperCase()
                    },{
                        type : '6', //[5]
                        name : 'xcno'
                    }, {
                        type : '1', //[6][7]
                        name : 'xdate'
                    }, {
                        type : '2', //[8][9]
                        name : 'xcust',
                        dbf : 'cust',
                        index : 'noa,comp',
                        src : 'cust_b.aspx'
                    }, {
                        type : '1', //[10][11]
                        name : 'xmon'
                    }, {
                        type : '2', //[12][13]
                        name : 'xsales',
                        dbf : 'sss',
                        index : 'noa,namea',
                        src : 'sss_b.aspx'
                    }, {
                        type : '6', //[14]
                        name : 'xmemo'
                    }, {
						type : '8',//[15]
						name : 'xoption01',
						value : 'detail@明細'.split('&')
					}]
                });
                q_popAssign();
                q_getFormat();
				q_langShow();
				
                $('#txtXdate1').mask('9999/99/99');
                $('#txtXdate2').mask('9999/99/99');
                $('#txtXmon1').mask('9999/99');
                $('#txtXmon2').mask('9999/99');
                
                $('#Xmemo').removeClass('a2').addClass('a1');
                $('#txtXmemo').css('width', '85%');
                $('.q_report .report').css('width', '460px');
                $('.q_report .report div').css('width', '220px');

               
                var t_date, t_year, t_month, t_day;
                t_date = new Date();
                t_date.setDate(1);
                t_year = t_date.getUTCFullYear() - 1911;
                t_year = t_year > 99 ? t_year + '' : '0' + t_year;
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
                t_year = t_date.getUTCFullYear() - 1911;
                t_year = t_year > 99 ? t_year + '' : '0' + t_year;
                t_month = t_date.getUTCMonth() + 1;
                t_month = t_month > 9 ? t_month + '' : '0' + t_month;
                t_day = t_date.getUTCDate();
                t_day = t_day > 9 ? t_day + '' : '0' + t_day;
                $('#txtXdate2').val(t_year + '/' + t_month + '/' + t_day);
                
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