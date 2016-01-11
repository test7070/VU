<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
	<head>
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">
            this.errorHandler = null;
            function onPageError(error) {
                alert("An error occurred:\r\n" + error.Message);
            }
			q_desc=1;
            q_tables = 's';
            var q_name = "cuc";
            var q_readonly = ['txtWorker', 'txtWorker2','textWeight'];
            var q_readonlys = [];
            var bbmNum = [];
            var bbsNum = [];
            var bbmMask = [];
            var bbsMask = [];
            q_sqlCount = 6;
            brwCount = 6;
            brwList = [];
            brwNowPage = 0;
            brwKey = 'Noa';
            brwCount2 = 6;
            aPop = new Array(
            	['txtCustno', 'lblCust', 'cust', 'noa,nick', 'txtCustno,txtCust', 'cust_b.aspx']
            );

            $(document).ready(function() {
                bbmKey = ['noa'];
                bbsKey = ['noa', 'noq'];
                q_brwCount();
                q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
                q_gt('spec', '1=1 ', 0, 0, 0, "bbsspec");
                q_gt('color', '1=1 ', 0, 0, 0, "bbscolor");
				q_gt('class', '1=1 ', 0, 0, 0, "bbsclass");
            });

            //////////////////   end Ready
            function main() {
                if (dataErr) {
                    dataErr = false;
                    return;
                }
                mainForm(1);
            }

            function mainPost() {
            	bbsNum = [ ['txtMount', 10, q_getPara('vcc.mountPrecision'), 1], ['txtMount1', 10, q_getPara('vcc.mountPrecision'), 1], ['txtWeight', 10, q_getPara('vcc.weightPrecision'), 1], ['txtLengthb', 15, 2, 1]];//['txtPrice', 12, q_getPara('vcc.pricePrecision'), 1],
                q_getFormat();
                bbmMask = [['txtDatea', r_picd],['txtBdate', r_picd]];
                bbsMask = [];
                q_mask(bbmMask);
				//q_cmbParse("combProduct", q_getPara('vccs_vu.product'),'s');
				
				var t_where = "where=^^ 1=1 ^^";
				q_gt('ucc', t_where, 0, 0, 0, "");
				
				$('#txtNoa').change(function() {
                    if ($(this).val().length > 0) {
                        t_where = "where=^^ noa='" + $(this).val() + "'^^";
                        q_gt('view_cuc', t_where, 0, 0, 0, "checkCucno_change", r_accy);
                    }
                });
				
				$('#checkGen').click(function() {
					if(q_cur==1 || q_cur==2){
						if($('#checkGen').prop('checked'))
							$('#txtGen').val(1);
						else
							$('#txtGen').val(0);
					}
				});
				
				$('#txtCustno').change(function() {
					if(!emp($('#txtCustno').val())){
						q_gt('custms', "where=^^noa='"+$('#txtCustno').val()+"'^^ ", 0, 0, 0, "custms");
					}else{
						$('#combAccount').text('');
					}
				});
				
				$('#combAccount').change(function() {
					if(q_cur==1 || q_cur==2)
						$('#txtMech').val($('#combAccount').find("option:selected").text());
				});
                
                $('#lblNoa').text('案號'); 
                $('#lblCust').text('客戶名稱');
                $('#lblMemo').text('備註');
                $('#lblDatea').text('日期'); 
                $('#lblGen').text('取消'); 
                $('#lblBdate').text('預交日');
                $('#lblMech').text('工地名稱');
                $('#lblWeight').text('料單總重量');
            }

            function q_popPost(s1) {
                switch(s1) {

                }
            }

            function q_boxClose(s2) {///   q_boxClose 2/4
                var ret;
                switch (b_pop) {
                    case q_name + '_s':
                        q_boxClose2(s2);
                        ///   q_boxClose 3/4
                        break;
                }/// end Switch
                b_pop = '';
            }

            function q_gtPost(t_name) {
                switch (t_name) {
                	case 'checkCucno_change':
						var as = _q_appendData("view_cuc", "", true);
                        if (as[0] != undefined) {
                            alert('案號【'+as[0].noa+'】已存在!!!');
                        }
                        break;
                	case 'checkCucno_btnOk':
                		var as = _q_appendData("view_cuc", "", true);
                        if (as[0] != undefined) {
                            alert('案號【'+as[0].noa+'】已存在!!!');
                            return;
                        } else {
                            wrServer($('#txtNoa').val());
                        }
                        break;
                	case 'custms':
                		var as = _q_appendData("custms", "", true);
                		var t_account='@';
                		for ( i = 0; i < as.length; i++) {
                			if(as[i].account!='')
                				t_account+=","+as[i].account;
                		}
                		$('#combAccount').text('');
                		q_cmbParse("combAccount", t_account);
                		break;
                	case 'ucc':
						var as = _q_appendData("ucc", "", true);
						var t_ucc='@';
						for ( i = 0; i < as.length; i++) {
							t_ucc+=","+as[i].product;
						}
						q_cmbParse("combProduct", t_ucc,'s');
						break;
                	case 'bbsspec':
						var as = _q_appendData("spec", "", true);
						var t_spec='@';
						for ( i = 0; i < as.length; i++) {
							t_spec+=","+as[i].noa;
						}
						q_cmbParse("combSpec", t_spec,'s');
						break;
					case 'bbscolor':
						var as = _q_appendData("color", "", true);
						var t_color='@';
						for ( i = 0; i < as.length; i++) {
							t_color+=","+as[i].color;
						}
						q_cmbParse("combUcolor", t_color,'s');
						break;
					case 'bbsclass':
						var as = _q_appendData("class", "", true);
						var t_class='@';
						for ( i = 0; i < as.length; i++) {
							t_class+=","+as[i].noa;
						}
						q_cmbParse("combClass", t_class,'s');
						break;
                    case q_name:
                        if (q_cur == 4)
                            q_Seek_gtPost();
                        break;
                }
            }

            function btnOk() {
                var t_err = q_chkEmpField([['txtNoa', q_getMsg('lblNoa')], ['txtDatea', q_getMsg('lblDatea')]]);
                if (t_err.length > 0) {
                    alert(t_err);
                    return;
                }
				
				var t_noa = trim($('#txtNoa').val());
				
                if (q_cur == 1){
                    $('#txtWorker').val(r_name);
                 	t_where = "where=^^ noa='" + t_noa + "'^^";
                    q_gt('view_cuc', t_where, 0, 0, 0, "checkCucno_btnOk", r_accy);   
                }else{
                    $('#txtWorker2').val(r_name);
                    wrServer(t_noa);
				}

                /*
                 11/10 不設定auto手動輸入
                 var s1 = $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val();
                var t_date = trim($('#txtDatea').val());
                if (s1.length == 0 || s1 == "AUTO")
                    q_gtnoa(q_name, replaceAll(q_getPara('sys.key_cuc') + (t_date.length == 0 ? q_date() : t_date), '/', ''));
                else
                    wrServer(s1);
                */
            }

            function _btnSeek() {
                if (q_cur > 0 && q_cur < 4)// 1-3
                    return;
                q_box('cuc_vu_s.aspx', q_name + '_s', "500px", "310px", q_getMsg("popSeek"));
            }

            function combPay_chg() {
            }

            function bbsAssign() {
                for (var j = 0; j < q_bbsCount; j++) {
                    if (!$('#btnMinus_' + j).hasClass('isAssign')) {
                    	$('#combUcolor_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtUcolor_'+b_seq).val($('#combUcolor_'+b_seq).find("option:selected").text());
						});
						$('#txtSize_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							 if ($(this).val().substr(0, 1) != '#')
                        		$(this).val('#' + $(this).val());
                        	bbsweight(b_seq);
						});
						
						$('#combSpec_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtSpec_'+b_seq).val($('#combSpec_'+b_seq).find("option:selected").text());
							//bbsweight(b_seq);
						});
						
						$('#txtLengthb_'+j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							bbsweight(b_seq);
						});
						
						$('#txtMount1_'+j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							bbsweight(b_seq);
						});
						
						$('#txtWeight_'+j).change(function() {
							weighttotal();
						}).focusin(function() {
							$(this).select();
						});
						
						$('#combClass_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtClass_'+b_seq).val($('#combClass_'+b_seq).find("option:selected").text());
						});
						
						$('#combProduct_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtProduct_'+b_seq).val($('#combProduct_'+b_seq).find("option:selected").text());
						});
						
						$('#checkMins_'+j).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2){
								if($('#checkMins_'+b_seq).prop('checked'))
									$('#txtMins_'+b_seq).val(1);
								else
									$('#txtMins_'+b_seq).val(0);
							}
							weighttotal();
						});
                    }
                }
                _bbsAssign();
                change_check();
                $('#lblOrdeno_s').text('訂單編號/訂序');
                $('#lblProduct_s').text('品名');
                $('#lblUcolor_s').text('類別');
                $('#lblSpec_s').text('材質');
                $('#lblSize_s').text('號數');
                $('#lblLengthb_s').text('長度(米)');
                $('#lblClass_s').text('廠牌');
                $('#lblUnit_s').text('單位');
                $('#lblMount1_s').text('支數');
                $('#lblMount_s').text('件數');
                $('#lblWeight_s').text('重量(KG)');
                $('#lblMemo_s').text('備註 (標籤)');
                $('#lblMins_s').text('完工');
                $('#vewNoa').text('案號');
                $('#vewCust').text('客戶');
                $('#lblSize2_s').text('工令');
                
                //1117複製功能
                $('#btnProductCopy').click(function() {
                	if(q_cur==1 || q_cur==2){
                		if(!emp($('#txtProduct_0').val())){
	                		for (var i = 1; i < q_bbsCount; i++) {
	                			if(emp($('#txtProduct_'+i).val())){
	                				$('#txtProduct_'+i).val($('#txtProduct_0').val());
	                			}
	                		}
                		}
                	}
				});
				
				$('#btnUcolorCopy').click(function() {
                	if(q_cur==1 || q_cur==2){
                		if(!emp($('#txtUcolor_0').val())){
	                		for (var i = 1; i < q_bbsCount; i++) {
	                			if(emp($('#txtUcolor_'+i).val())){
	                				$('#txtUcolor_'+i).val($('#txtUcolor_0').val());
	                			}
	                		}
                		}
                	}
				});
				
				$('#btnSpecCopy').click(function() {
                	if(q_cur==1 || q_cur==2){
                		if(!emp($('#txtSpec_0').val())){
	                		for (var i = 1; i < q_bbsCount; i++) {
	                			if(emp($('#txtSpec_'+i).val())){
	                				$('#txtSpec_'+i).val($('#txtSpec_0').val());
	                			}
	                		}
                		}
                	}
				});
				
				$('#btnSizeCopy').click(function() {
                	if(q_cur==1 || q_cur==2){
                		if(!emp($('#txtSize_0').val())){
	                		for (var i = 1; i < q_bbsCount; i++) {
	                			if(emp($('#txtSize_'+i).val())){
	                				$('#txtSize_'+i).val($('#txtSize_0').val());
	                			}
	                		}
                		}
                	}
				});
				
				$('#btnClassCopy').click(function() {
                	if(q_cur==1 || q_cur==2){
                		if(!emp($('#txtClass_0').val())){
	                		for (var i = 1; i < q_bbsCount; i++) {
	                			if(emp($('#txtClass_'+i).val())){
	                				$('#txtClass_'+i).val($('#txtClass_0').val());
	                			}
	                		}
                		}
                	}
				});
				
				$('#btnMemoCopy').click(function() {
                	if(q_cur==1 || q_cur==2){
                		if(!emp($('#txtMemo_0').val())){
	                		for (var i = 1; i < q_bbsCount; i++) {
	                			if(emp($('#txtMemo_'+i).val())){
	                				$('#txtMemo_'+i).val($('#txtMemo_0').val());
	                			}
	                		}
                		}
                	}
				});
				
				$('#btnSize2Copy').click(function() {
                	if(q_cur==1 || q_cur==2){
                		if(!emp($('#txtSize2_0').val())){
	                		for (var i = 1; i < q_bbsCount; i++) {
	                			if(emp($('#txtSize2_'+i).val())){
	                				$('#txtSize2_'+i).val($('#txtSize2_0').val());
	                			}
	                		}
                		}
                	}
				});
				
				//1124 新增
				$('#btnOrdeCopy').click(function() {
					if(q_cur==1 || q_cur==2){
                		if(!emp($('#txtOrdeno_0').val())){
                			var t_no2='000';
	                		for (var i = 0; i < q_bbsCount; i++) {
	                			if(emp($('#txtOrdeno_'+i).val())){
	                				$('#txtOrdeno_'+i).val($('#txtOrdeno_0').val());
	                			}
	                			if($('#txtOrdeno_'+i).val()==$('#txtOrdeno_0').val() && !emp($('#txtNo2_'+i).val())){
	                				if(dec(t_no2)<dec($('#txtNo2_'+i).val()))
	                					t_no2=$('#txtNo2_'+i).val();
	                			}else if($('#txtOrdeno_'+i).val()==$('#txtOrdeno_0').val() && emp($('#txtNo2_'+i).val())){
	                				$('#txtNo2_'+i).val(('000'+(dec(t_no2)+1)).slice(-3));
	                				t_no2=$('#txtNo2_'+i).val();
	                			}
	                			
	                		}
                		}
                	}
				});
            }
            
            function bbsweight(n) {
            	var t_siez=replaceAll($('#txtSize_'+n).val(),'#','');
            	var t_weight=0;
            	switch(t_siez){
            		case '3': t_weight=0.560; break;
            		case '4': t_weight=0.994; break;
            		case '5': t_weight=1.560; break;
            		case '6': t_weight=2.250; break;
            		case '7': t_weight=3.040; break;
            		case '8': t_weight=3.980; break;
            		case '9': t_weight=5.080; break;
            		case '10': t_weight=6.390; break;
            		case '11': t_weight=7.900; break;
            		case '12': t_weight=9.570; break;
            		case '14': t_weight=11.40; break;
            		case '16': t_weight=15.50; break;
            		case '18': t_weight=20.20; break;
            	}
            	
            	var t_lengthb=dec($('#txtLengthb_'+n).val());
            	var t_mount1=dec($('#txtMount1_'+n).val());
            	
            	$('#txtWeight_'+n).val(round(q_mul(q_mul(t_weight,t_lengthb),t_mount1),0));
            	weighttotal()
            }
            
            function weighttotal() {
            	var t_weight=0;
            	for (var j = 0; j < q_bbsCount; j++) {
            		t_weight=q_add(t_weight,dec($('#txtWeight_'+j).val()));
            	}
            	$('#textWeight').val(FormatNumber(t_weight));
			}
			
            function btnIns() {
                _btnIns();
                //$('#txtNoa').val('AUTO');
                $('#txtDatea').val(q_date()).focus();
                refreshBbm();
            }

            function btnModi() {
                if (emp($('#txtNoa').val()))
                    return;
                _btnModi();
                refreshBbm();
                if(!emp($('#txtCustno').val())){
					q_gt('custms', "where=^^noa='"+$('#txtCustno').val()+"'^^ ", 0, 0, 0, "custms");	
				}
            }

            function btnPrint() {
				var t_where = "noa='" + $.trim($('#txtNoa').val()) + "'";
               	q_box("z_cucp_vu.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, '', "95%", "95%", q_getMsg('popPrint'));
            }

            function wrServer(key_value) {
                var i;

                $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
                _btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
            }

            function bbsSave(as) {
                if (!as['ordeno'] && !as['product']) {
                    as[bbsKey[1]] = '';
                    return;
                }

                q_nowf();

                return true;
            }

            ///////////////////////////////////////////////////  以下提供事件程式，有需要時修改
            function refresh(recno) {
                _refresh(recno);
                change_check();
                weighttotal();
                refreshBbm();
                
                if(!emp($('#txtCustno').val())){
					q_gt('custms', "where=^^noa='"+$('#txtCustno').val()+"'^^ ", 0, 0, 0, "custms");
				}
            }

            function readonly(t_para, empty) {
                _readonly(t_para, empty);
                change_check();
            }
            
            function refreshBbm() {
                if (q_cur == 1) {
                    $('#txtNoa').css('color', 'black').css('background', 'white').removeAttr('readonly');
                } else {
                    $('#txtNoa').css('color', 'green').css('background', 'RGB(237,237,237)').attr('readonly', 'readonly');
                }
            }

            function btnMinus(id) {
                _btnMinus(id);
            }

            function btnPlus(org_htm, dest_tag, afield) {
                _btnPlus(org_htm, dest_tag, afield);
            }

            function q_appendData(t_Table) {
                return _q_appendData(t_Table);
            }

            function btnSeek() {
                _btnSeek();
            }

            function btnTop() {
                _btnTop();
            }

            function btnPrev() {
                _btnPrev();
            }

            function btnPrevPage() {
                _btnPrevPage();
            }

            function btnNext() {
                _btnNext();
            }

            function btnNextPage() {
                _btnNextPage();
            }

            function btnBott() {
                _btnBott();
            }

            function q_brwAssign(s1) {
                _q_brwAssign(s1);
            }

            function btnDele() {
                _btnDele();
            }

            function btnCancel() {
                _btnCancel();
            }
            
            function change_check() {
            	if(q_cur==1 || q_cur==2){
            		$('#checkGen').removeAttr('disabled');
            	}else{
            		$('#checkGen').attr('disabled', 'disabled');
            	}
            	if($('#txtGen').val()==0){
					$('#checkGen').prop('checked',false);
				}else{
					$('#checkGen').prop('checked',true);
				}
            	
				for (var i = 0; i < q_bbsCount; i++) {
					if(q_cur==1 || q_cur==2){
						$('#checkMins_'+i).removeAttr('disabled');
					}else{
						$('#checkMins_'+i).attr('disabled', 'disabled');
					}
					if($('#txtMins_'+i).val()==0){
						$('#checkMins_'+i).prop('checked',false);
					}else{
						$('#checkMins_'+i).prop('checked',true);
					}
				}
			}
			
			function FormatNumber(n) {
				var xx = "";
				if (n < 0) {
					n = Math.abs(n);
					xx = "-";
				}
				n += "";
				var arr = n.split(".");
				var re = /(\d{1,3})(?=(\d{3})+$)/g;
				return xx + arr[0].replace(re, "$1,") + (arr.length == 2 ? "." + arr[1] : "");
			}
		</script>
		<style type="text/css">
            #dmain {
                /*overflow: hidden;*/
            }
            .dview {
                float: left;
                border-width: 0px;
                width: 30%;
            }
            .tview {
                border: 5px solid gray;
                font-size: medium;
                background-color: black;
            }
            .tview tr {
                height: 30px;
            }
            .tview td {
                padding: 2px;
                text-align: center;
                border-width: 0px;
                background-color: #FFFF66;
                color: blue;
            }
            .dbbm {
                float: left;
                width: 70%;
                /*margin: -1px;
                 border: 1px black solid;*/
                border-radius: 5px;
            }
            .tbbm {
                padding: 0px;
                border: 1px white double;
                border-spacing: 0;
                border-collapse: collapse;
                font-size: medium;
                color: blue;
                background: #cad3ff;
                width: 100%;
            }
            .tbbm tr {
                height: 35px;
            }
            .tbbm tr td {
                width: 9%;
            }
            .tbbm .tdZ {
                width: 1%;
            }
            .tbbm tr td span {
                float: right;
                display: block;
                width: 5px;
                height: 10px;
            }
            .tbbm tr td .lbl {
                float: right;
                color: black;
                font-size: medium;
            }
            .tbbm tr td .lbl.btn {
                color: #4297D7;
                font-weight: bolder;
                font-size: medium;
            }
            .tbbm tr td .lbl.btn:hover {
                color: #FF8F19;
            }
            .txt.c1 {
                width: 98%;
                float: left;
            }

            .num {
                text-align: right;
            }
            .tbbm td {
                margin: 0 -1px;
                padding: 0;
            }
            .tbbm td input[type="text"] {
                border-width: 1px;
                padding: 0px;
                margin: -1px;
                float: left;
            }
            input[type="text"], input[type="button"] ,select{
                font-size: medium;
            }
            .dbbs {
                width: 100%;
            }
            .dbbs .tbbs {
                margin: 0;
                padding: 2px;
                border: 2px lightgrey double;
                border-spacing: 1;
                border-collapse: collapse;
                font-size: medium;
                color: blue;
                /*background: #cad3ff;*/
                background: lightgrey;
                width: 100%;
            }
            .dbbs .tbbs tr {
                height: 35px;
            }
            .dbbs .tbbs tr td {
                text-align: center;
                border: 2px lightgrey double;
            }
            .dbbs .tbbs select {
                border-width: 1px;
                padding: 0px;
                margin: -1px;
                font-size: medium;
            }
		</style>
	</head>
	<body>
		<!--#include file="../inc/toolbar.inc"-->
		<div id='dmain' >
			<div class="dview" id="dview" >
				<table class="tview" id="tview" >
					<tr>
						<td align="center" style="width:5%"><a id='vewChk'> </a></td>
						<td align="center" style="width:20%"><a id='vewNoa'> </a></td>
						<td align="center" style="width:25%"><a id='vewCust'> </a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" style=' '/></td>
						<td align="center" id='noa'>~noa</td>
						<td align="center" id='cust'>~cust</td>
					</tr>
				</table>
			</div>
			<div class='dbbm'>
				<table class="tbbm" id="tbbm">
					<tr>
						<td><span> </span><a id="lblNoa" class="lbl"> </a></td>
						<td><input id="txtNoa"  type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblDatea" class="lbl"> </a></td>
						<td><input id="txtDatea"  type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblBdate" class="lbl"> </a></td>
						<td><input id="txtBdate"  type="text" class="txt c1"/></td>
						<td> </td>
					</tr>
					<tr>
						<td><span> </span><a id="lblCust" class="lbl btn"> </a></td>
						<td><input id="txtCustno"  type="text" class="txt c1"/></td>
						<td colspan="2"><input id="txtCust"  type="text" class="txt c1"/> </td>
						<td><span> </span><a id="lblMech" class="lbl"> </a></td>
						<td colspan="2">
							<input id="txtMech"  type="text" class="txt c1" style="width: 90%;"/>
							<select id="combAccount" class="txt" style="width: 20px;"> </select>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id="lblMemo" class="lbl"> </a></td>
						<td colspan="3"><input id="txtMemo"  type="text" class="txt c1"/></td>
						<td> </td>
						<td> </td>
						<td> </td>
					</tr>
					<tr>
						<td><span> </span><a id="lblWorker" class="lbl"> </a></td>
						<td><input id="txtWorker" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblWorker2" class="lbl"> </a></td>
						<td><input id="txtWorker2" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblGen" class="lbl"> </a></td>
						<td>
							<input id="checkGen" type="checkbox"/>
							<input id="txtGen" type="hidden"/>
						</td>
						<td><span> </span><a id="lblWeight" class="lbl"> </a></td>
						<td><input id="textWeight" type="text" class="txt num c1"/></td>
					</tr>
				</table>
			</div>
			<div class='dbbs' >
				<table id="tbbs" class='tbbs'  border="1"  cellpadding='2' cellspacing='1'  >
					<tr style='color:White; background:#003366;'>
						<td align="center" style="width: 1%;"><input class="btn"  id="btnPlus" type="button" value='+' style="font-weight: bold;"  /></td>
						<td align="center" style="width: 150px;"><a id='lblOrdeno_s'> </a><input class="btn"  id="btnOrdeCopy" type="button" value='≡' style="font-weight: bold;"  /></td>
						<td style="width:150px;"><a id='lblProduct_s'> </a><input class="btn"  id="btnProductCopy" type="button" value='≡' style="font-weight: bold;"  /></td>
						<td style="width:150px;"><a id='lblUcolor_s'> </a><input class="btn"  id="btnUcolorCopy" type="button" value='≡' style="font-weight: bold;"  /></td>
						<td style="width:150px;"><a id='lblSpec_s'> </a><input class="btn"  id="btnSpecCopy" type="button" value='≡' style="font-weight: bold;"  /></td>
						<td style="width:85px;"><a id='lblSize_s'> </a><input class="btn"  id="btnSizeCopy" type="button" value='≡' style="font-weight: bold;"  /></td>
						<td style="width:85px;"><a id='lblLengthb_s'> </a></td>
						<!--<td style="width:55px;"><a id='lblUnit_s'> </a></td>-->
						<td style="width:85px;"><a id='lblMount1_s'> </a></td>
						<td style="width:85px;"><a id='lblMount_s'> </a></td>
						<td style="width:85px;"><a id='lblWeight_s'> </a></td>
						<td style="width:120px;"><a id='lblClass_s'> </a><input class="btn"  id="btnClassCopy" type="button" value='≡' style="font-weight: bold;"  /></td>
						<td style="width:150px;"><a id='lblMemo_s'> </a><input class="btn"  id="btnMemoCopy" type="button" value='≡' style="font-weight: bold;"  /></td>
						<td style="width:150px;"><a id='lblSize2_s'> </a><input class="btn"  id="btnSize2Copy" type="button" value='≡' style="font-weight: bold;"  /></td>
						<td style="width:40px;"><a id='lblMins_s'> </a></td>
					</tr>
					<tr  style='background:#cad3ff;'>
						<td align="center"><input class="btn" id="btnMinus.*" type="button" value='-' style=" font-weight: bold;" /></td>
						<td>
							<input id="txtOrdeno.*" type="text" class="txt c1" />
							<input id="txtNo2.*" type="text" class="txt c1" />
							<input id="txtNoq.*" type="hidden"/>
						</td>
						<td>
							<input id="txtProduct.*" type="text" class="txt c1" style="width: 70%;"/>
							<select id="combProduct.*" class="txt" style="width: 20px;"> </select>
						</td>
						<td>
							<input id="txtUcolor.*" type="text" class="txt c1" style="width: 110px;"/>
							<select id="combUcolor.*" class="txt" style="width: 20px;"> </select>
						</td>
						<td>
							<input id="txtSpec.*" type="text" class="txt c1" style="width: 70%;"/>
							<select id="combSpec.*" class="txt" style="width: 20px;"> </select>
						</td>
						<td><input id="txtSize.*" type="text" class="txt c1" /></td>
						<td><input id="txtLengthb.*" type="text" class="txt num c1" /></td>
						<!--<td><input id="txtUnit.*" type="text" class="txt c1"/></td>-->
						<td><input id="txtMount1.*" type="text" class="txt num c1"/></td>
						<td><input id="txtMount.*" type="text" class="txt num c1"/></td>
						<td><input id="txtWeight.*" type="text" class="txt num c1"/></td>
						<td>
							<input id="txtClass.*" type="text" class="txt c1" style="width: 70%;"/>
							<select id="combClass.*" class="txt" style="width: 20px;"> </select>
						</td>
						<td><input id="txtMemo.*" type="text" class="txt c1"/></td>
						<td><input id="txtSize2.*" type="text" class="txt c1"/></td>
						<td>
							<input id="checkMins.*" type="checkbox"/>
							<input id="txtMins.*" type="hidden"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>
