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
            if (location.href.indexOf('?') < 0) {
                location.href = location.href + "?;;;;" + ((new Date()).getUTCFullYear() - 1911);
            }
            $(document).ready(function() {
                q_getId();
                q_gf('', 'z_ordhp_vu');
                
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
                    fileName : 'z_ordhp_vu',
                    options : [{
                        type : '1',//[1][2]
                        name : 'xdate'
                    }, {
                        type : '5',//[3]
                        name : 'xtypea',
                        value :'#non@全部,委外代工,來料加工,互換'.split(',')
                    }, {
                        type : '2',//[4][5]
                        name : 'xtggno',
                        dbf : 'tgg',
                        index : 'noa,comp',
                        src : 'tgg_b.aspx'
                    }, {
                        type : '6',//[6]
                        name : 'xnoa'
                    }, {
                        type : '8',//[7]
                        name : 'xshowtgg',
                        value : "1@廠商統計".split(',')
                    }, {
                        type : '8',//[8]
                        name : 'xshowend',
                        value : "1@含合約中止".split(',')
                    }]
                });
                q_popAssign();
                q_getFormat();
                q_langShow();

                //戴先生 2017/06/22 訂約日要往前推一年
                $('#txtXdate1').mask(r_picd);
                $('#txtXdate1').val(q_cdn(q_date().substr(0, r_lenm)+'/01',-365).substr(0,r_lenm)+'/01');
                $('#txtXdate2').mask(r_picd);
                $('#txtXdate2').val(q_cdn(q_cdn(q_date().substr(0,r_lenm)+'/01',35).substr(0,r_lenm)+'/01',-1));
                
                $('#Xshowtgg').css('width', '300px').css('height', '30px');
                $('#Xshowtgg .label').css('width','0px');
                $('#chkXshowtgg').css('width', '220px').css('margin-top', '5px');
                $('#chkXshowtgg span').css('width','180px')
                $('#Xshowend').css('width', '300px').css('height', '30px');
                $('#Xshowend .label').css('width','0px');
                $('#chkXshowend').css('width', '220px').css('margin-top', '5px');
                $('#chkXshowend span').css('width','180px')
            }

            function q_boxClose(s2) {
            }
			
			var partItem = '';
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
		<div id="q_menu"> </div>
		<div style="position: absolute;top: 10px;left:50px;z-index: 1;">
			<div id="container">
				<div id="q_report"> </div>
			</div>
			<div class="prt" style="margin-left: -40px;">
				<!--#include file="../inc/print_ctrl.inc"-->
			</div>
		</div>
	</body>
</html>