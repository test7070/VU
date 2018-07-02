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
            t_isinit = false;
            $(document).ready(function() {
                q_getId();
                q_gf('', 'z_umm_vu');

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
						value : 'detail@明細,zero@零值顯示'.split(',')
					},{
                        type : '6', //[16]
                        name : 'xqno'
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
                
                $('#txtXmon1').val(q_date().substr(0,r_lenm));
                $('#txtXmon2').val(q_date().substr(0,r_lenm));
                //105/08/05預設抓半年 //107/06/28 SF改成1年半
                if(q_getPara('sys.project').toUpperCase()=='SF'){
                	$('#txtXdate1').val(q_cdn(q_date().substr(0,r_lenm)+'/15',-521).substr(0,r_lenm)+'/01');
                }else{
                	$('#txtXdate1').val(q_cdn(q_date().substr(0,r_lenm)+'/15',-155).substr(0,r_lenm)+'/01');
                }
                $('#txtXdate2').val(q_cdn(q_cdn(q_date().substr(0,r_lenm)+'/01',45).substr(0,r_lenm)+'/01',-1));
                
                //107/06/28 預設開啟
                $('#Xoption01 [type=checkbox]').first().prop('checked',true);
                
                
                if(window.parent.q_name=="z_quatp_vu"){
                	var t_qno='';
                	var t_bdate='';
                	var t_report='';
                	if(q_getHref()[1]!=undefined){t_qno=q_getHref()[1];}
                	if(q_getHref()[3]!=undefined){t_bdate=q_getHref()[3];}
                	if(q_getHref()[5]!=undefined){t_report=q_getHref()[5];}
                	
                	var t_i=-1;
					for(var i=0;i<$('#q_report').data().info.reportData.length;i++){
						if($('#q_report').data().info.reportData[i].report!=t_report)
							$('#q_report div div').eq(i).hide();
						else{
							t_i=i;
						}
					}
					if(t_i>-1){
						$('#txtXqno').val(t_qno);
						$('#txtXdate1').val(t_bdate);
						
						$('#q_report .report div').eq(t_i).click();
	 					$('#btnOk').click();
 					}
				}
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