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
            t_cno = '';
            t_isinit = false;
            var z_cno=r_cno,z_acomp=r_comp;
            $(document).ready(function() {
                q_getId();
                q_gf('', 'z_ucca_vu');
            });
            
            function q_gfPost() {
                //q_gt('acomp', '', 0, 0, 0);
                q_gt('acomp', 'stop=1 ', 0, 0, 0);
            }
			var uccaItem=' @全部';
            function q_gtPost(t_name) {
                switch (t_name) {
                    case 'acomp':
                       var as = _q_appendData("acomp", "", true);
                       if (as[0] != undefined) {
	                		z_cno=as[0].noa;
	                		z_acomp=as[0].acomp;
	                	}
	                	q_gt('ucca', ' stop=1000 ', 0, 0, 0, "ucca"); 
                        break;
					case 'ucca':
						var as = _q_appendData("ucca", "", true);
						for ( i = 0; i < as.length; i++) {
							uccaItem+=","+as[i].product;
						}
						
						LoadFinish();
						break;
                }
            }

            function LoadFinish() {
                $('#q_report').q_report({
                    fileName : 'z_ucca_vu',
                    options : [{/*0 [1]*/
                        type : '0',
                        name : 'accy',
                        value : r_accy
                    }, {/*1 [2][3]*/
                        type : '1',
                        name : 'xdate'
                    }, {/*2 [4]*/
                        type : '5',
                        name : 'xproduct',
                        value :uccaItem.split(',')
                    }, {/*3 [5]*/
                        type : '5',
                        name : 'xtype',
                        value : [' @全部','2@二聯','3@三聯']
                    }, {/*4 [6]*/
                        type : '6',
                        name : 'xcno'
                    }, {/*5 [7]*/
                        type : '6',
                        name : 'enddate'
                    }, {
						type : '0', //[8] 
						name : 'xproject',
						value : q_getPara('sys.project').toUpperCase()
					}, {
						type : '0', //[9] 
						name : 'xlenm',
						value : r_lenm
					}]
                });
                
                q_popAssign();
                q_langShow();
                
                if(r_len==4){                	
                	$.datepicker.r_len=4;
					//$.datepicker.setDefaults($.datepicker.regional["ENG"]);
                }
                
                $('#txtEnddate').mask(r_picd);
                $('#txtXdate1').mask(r_picd);
                $('#txtXdate2').mask(r_picd);
                $('#txtEnddate').datepicker();
				$('#txtXdate1').datepicker();
				$('#txtXdate2').datepicker();
				$('#txtEnddate').val(q_date());
				
                $('#txtXdate1').val(q_date().substr(0,r_lenm)+'/01');
                $('#txtXdate2').val(q_cdn(q_cdn(q_date().substr(0, r_lenm)+'/01',35).substr(0,r_lenm)+'/01',-1));
                
                $('#Xcno').css("width","300px");
                $('#txtXcno').css("width","90px");
                
                var tmp = document.getElementById("txtXcno");
                var t_input = document.createElement("input");
                t_input.id='txtXacomp'
                t_input.type='text'
                t_input.className = "c2 text";
                t_input.disabled='disabled'
                tmp.parentNode.appendChild(t_input,tmp);
                aPop.push(['txtXcno','lblXcno','acomp','noa,acomp','txtXcno,txtXacomp','acomp_b.aspx']);
                
                $('#txtXcno').val(z_cno);
                $('#txtXacomp').val(z_acomp);
                
            }

            function q_boxClose(s2) {
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