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

			q_tables = 's';
			var q_name = "rc2";
			var q_readonly = ['txtNoa', 'txtAcomp', 'txtTgg', 'txtWorker', 'txtWorker2','txtMoney','txtTotal','txtOrdeno'];
			var q_readonlys = ['txtNoq','txtOrdeno','txtNo2','txtStore'];
			var bbmNum = [];
			var bbsNum = [];
			var bbmMask = [];
			var bbsMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwCount2 = 16;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'datea';
			aPop = new Array(
				['txtTggno', 'lblTgg', 'tgg', 'noa,nick,tel,zip_home,addr_home,paytype', 'txtTggno,txtTgg,txtTel,txtPost,txtAddr,txtPaytype', 'tgg_b.aspx'],
				['txtStoreno_', 'btnStoreno_', 'store', 'noa,store', 'txtStoreno_,txtStore_', 'store_b.aspx'],
				//['txtPost', 'lblAddr', 'addr', 'post,addr', 'txtPost,txtAddr', 'addr_b.aspx'],
				//['txtPost2', 'lblAddr2', 'addr', 'post,addr', 'txtPost2,txtAddr2', 'addr_b.aspx'],
				['txtPost', 'lblAddr', 'addr2', 'noa,post', 'txtPost,txtAddr', 'addr2_b.aspx'],
				['txtPost2', 'lblAddr2', 'addr2', 'noa,post', 'txtPost2,txtAddr2', 'addr2_b.aspx'],
				['txtCardealno', 'lblCardeal', 'cardeal', 'noa,comp', 'txtCardealno,txtCardeal', 'cardeal_b.aspx'],
				['txtCno', 'lblAcomp', 'acomp', 'noa,acomp,addr', 'txtCno,txtAcomp,txtAddr2', 'acomp_b.aspx']
				//['txtProductno_', 'btnProductno_', 'ucaucc', 'noa,product,unit,spec', 'txtProductno_,txtProduct_,txtUnit_,txtSpec_,txtUcolor_', 'ucaucc_b.aspx'],
				//['txtCarno', 'lblCar', 'cardeal', 'noa', '0txtCarno', 'cardeal_b.aspx']
			);

			$(document).ready(function() {
				bbmKey = ['noa'];
				bbsKey = ['noa', 'noq'];
				q_brwCount();
				q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
				q_gt('acomp', 'stop=1 ', 0, 0, 0, "cno_acomp");
				q_gt('spec', '1=1 ', 0, 0, 0, "bbsspec");
				q_gt('color', '1=1 ', 0, 0, 0, "bbscolor");
				q_gt('class', '1=1 ', 0, 0, 0, "bbsclass");
			});

			function main() {
				if (dataErr) {
					dataErr = false;
					return;
				}
				mainForm(1);
			}

			function sum() {
				var t1 = 0, t_unit, t_mount, t_weight = 0,t_money=0, t_tax = 0, t_total = 0;
				for (var j = 0; j < q_bbsCount; j++) {
					t_unit = trim($('#txtUnit_' + j).val());
					if (t_unit.length == 0 || t_unit == 'KG' || t_unit == 'M2' || t_unit == 'M' || t_unit == '批' || t_unit == '公斤' || t_unit == '噸' || t_unit == '頓' || t_unit == 'T') {
						t_mount = $('#txtWeight_' + j).val();
					}else{
						t_mount = $('#txtMount_' + j).val();
					}
					t_weight=+q_float('txtMount_' + j);
					$('#txtTotal_' + j).val(round(q_mul(q_float('txtPrice_' + j), dec(t_mount)), 0));
					t_money = q_add(t_money, dec(q_float('txtTotal_' + j)));
				}
				if($('#chkAtax').prop('checked')){
					var t_taxrate = q_div(parseFloat(q_getPara('sys.taxrate')), 100);
					t_tax = round(q_mul(t_money, t_taxrate), 0);
					t_total = q_add(t_money, t_tax);
				}else{
					t_tax = q_float('txtTax');
					t_total = q_add(t_money, t_tax);
				}
				$('#txtMoney').val(FormatNumber(t_money));
				$('#txtTax').val(FormatNumber(t_tax));
				$('#txtTotal').val(FormatNumber(t_total));
			}

			function mainPost() {
				q_getFormat();
				bbmMask = [['txtDatea', r_picd], ['txtMon', r_picm]];
				q_mask(bbmMask);
				bbmNum = [['txtMoney', 15, 0, 1], ['txtTax', 10, 0, 1], ['txtTotal', 15, 0, 1],['txtTranmoney',15,0,1]
								,['txtTranadd', 15, q_getPara('rc2.weightPrecision'), 1],['txtBenifit', 15, q_getPara('rc2.weightPrecision'), 1],['txtWeight', 15, q_getPara('rc2.weightPrecision'), 1]
								,['textQweight1', 15, q_getPara('rc2.weightPrecision'), 1],['textQweight2', 15, q_getPara('rc2.weightPrecision'), 1]];
				bbsNum = [['txtMount', 15, q_getPara('rc2.mountPrecision'), 1],['txtWeight', 15, q_getPara('rc2.weightPrecision'), 1], ['txtPrice', 15, q_getPara('rc2.pricePrecision'), 1]
								, ['txtTotal', 15, 0, 1], ['txtLengthb', 15, 2, 1]];
				
				//q_cmbParse("cmbTranstyle", q_getPara('sys.transtyle'));
				q_cmbParse("cmbTypea", q_getPara('rc2.typea'));
				q_cmbParse("cmbStype", q_getPara('rc2.stype'));
				q_cmbParse("combPaytype", q_getPara('rc2.paytype'));
				q_cmbParse("cmbTrantype", q_getPara('sys.tran'));
				//q_cmbParse("combUcolor", q_getPara('rc2s_vu.typea'),'s');
				//q_cmbParse("cmbTaxtype", q_getPara('sys.taxtype'));
				q_cmbParse("combProduct", q_getPara('rc2s_vu.product'),'s');
				
				var t_where = "where=^^ 1=1 group by post,addr^^";
				q_gt('custaddr', t_where, 0, 0, 0, "");
				
				$('#lblOrdc').text('合約號碼');
				$('#lblTranadd').text('車空重');
				$('#lblBenifit').text('車總重');
				$('#lblWeight').text('淨重');
				
				$('#txtTranadd').change(function() {
					q_tr('txtWeight',q_sub(q_float('txtBenifit'),q_float('txtTranadd')))
				});
				$('#txtBenifit').change(function() {
					q_tr('txtWeight',q_sub(q_float('txtBenifit'),q_float('txtTranadd')))
				});
				
				//限制帳款月份的輸入 只有在備註的第一個字為*才能手動輸入					
				$('#txtMemo').change(function(){
					if ($('#txtMemo').val().substr(0,1)=='*')
						$('#txtMon').removeAttr('readonly');
					else
						$('#txtMon').attr('readonly', 'readonly');
				});
				
				$('#txtMon').click(function(){
					if ($('#txtMon').attr("readonly")=="readonly" && (q_cur==1 || q_cur==2))
						q_msg($('#txtMon'), "月份要另外設定，請在"+q_getMsg('lblMemo')+"的第一個字打'*'字");
				});
				
				$('#chkAtax').click(function() {
					refreshBbm();
					sum();
				});
				
				$('#txtTax').change(function() {
					sum();
				});
				
				$('#lblAccc').click(function() {
					q_pop('txtAccno', "accc.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";accc3='" + $('#txtAccno').val() + "';" + $('#txtDatea').val().substring(0, 3) + '_' + r_cno, 'accc', 'accc3', 'accc2', "92%", "1054px", q_getMsg('lblAccc'), true);
				});
				
				$('#lblOrdc').click(function() {
					t_where = '';
					t_contno = $('#txtOrdcno').val();
					if (t_invo.length > 0) {
						t_where = "noa='" +t_contno + "'";
						q_box("contst_vu.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'contst', "95%", "95%", '進貨合約');
					}
				});
				
				$('#lblInvono').click(function() {
					t_where = '';
					t_invo = $('#txtInvono').val();
					if (t_invo.length > 0) {
						t_where = "noa='" + t_invo + "'";
						q_box("rc2a.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'rc2a', "95%", "95%", q_getMsg('popRc2a'));
					}
				});
								
				$('#txtTotal').change(function() {
					sum();
				});
				
				$('#txtTggno').change(function() {
					if (!emp($('#txtTggno').val())) {
						var t_where = "where=^^ noa='" + $('#txtTggno').val() + "' group by post,addr^^";
						q_gt('custaddr', t_where, 0, 0, 0, "");
					}
				});

				$('#txtAddr').change(function() {
					var t_tggno = trim($(this).val());
					if (!emp(t_tggno)) {
						focus_addr = $(this).attr('id');
						zip_fact = $('#txtPost').attr('id');
						var t_where = "where=^^ noa='" + t_tggno + "' ^^";
						q_gt('tgg', t_where, 0, 0, 0, "");
					}
				});
				
				$('#txtAddr2').change(function() {
					var t_custno = trim($(this).val());
					if (!emp(t_custno)) {
						focus_addr = $(this).attr('id');
						zip_fact = $('#txtPost2').attr('id');
						var t_where = "where=^^ noa='" + t_custno + "' ^^";
						q_gt('cust', t_where, 0, 0, 0, "");
					}
				});
				
				$('#txtCardealno').change(function() {
					//取得車號下拉式選單
					var thisVal = $(this).val();
					var t_where = "where=^^ noa=N'" + thisVal + "' ^^";
					q_gt('cardeal', t_where, 0, 0, 0, "getCardealCarno");
				});
					
				$('#txtPrice').change(function(){
					sum();
				});
				
				$('#lblQno1').click(function() {
					var t_where="tggno='"+$('#txtTggno').val()+"' and eweight>0 ";
					if(q_cur==1 || q_cur==2)
						t_where=t_where+" and noa!='"+$('#textQno2').val()+"'";
					q_box("contst_vu_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'cont1_b', "600px", "700px", '進貨合約');
				});
				
				$('#lblQno2').click(function() {
					var t_where="tggno='"+$('#txtTggno').val()+"' and eweight>0";
					if(q_cur==1 || q_cur==2)
						t_where=t_where+" and noa!='"+$('#textQno1').val()+"'";
					q_box("contst_vu_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'cont2_b', "600px", "700px",  '進貨合約');
				});
				
			}
			
			function refreshBbm() {
                if (q_cur == 1 || q_cur==2) {
					if($('#chkAtax').prop('checked'))
						$('#txtTax').css('color', 'green').css('background', 'RGB(237,237,237)').attr('readonly', 'readonly');
					else
						$('#txtTax').css('color', 'black').css('background', 'white').removeAttr('readonly');  
                }else{
                	$('#txtTax').css('color', 'green').css('background', 'RGB(237,237,237)').attr('readonly', 'readonly');
                }
            }
            
            function HiddenTreat(){
				var t_quat=$('#txtTranstart').val().split('##');
				if(t_quat[0]!=undefined){
					var r_quat=t_quat[0].split('@');
					if(r_quat[0]!=undefined)
						$('#textQno1').val(r_quat[0]);
					else
						$('#textQno1').val('');
					if(r_quat[1]!=undefined){
						$('#textQweight1').val(r_quat[1]);
					}else{
						$('#textQweight1').val(0);
					}
				}
				if(t_quat[1]!=undefined){
					var r_quat=t_quat[1].split('@');
					if(r_quat[0]!=undefined)
						$('#textQno2').val(r_quat[0]);
					else
						$('#textQno2').val('');
					if(r_quat[1]!=undefined){
						$('#textQweight2').val(r_quat[1]);
					}else{
						$('#textQweight2').val(0);
					}
				}
			}

			function q_boxClose(s2) {
				var ret;
				switch (b_pop) {
					case 'cont1_b':
						if (q_cur > 0 && q_cur < 4) {
							b_ret = getb_ret();
							if (!b_ret || b_ret.length == 0 || b_ret[0]==undefined)
								return;
							$('#textQno1').val(b_ret[0].noa);
						}
						break;
					case 'cont2_b':
						if (q_cur > 0 && q_cur < 4) {
							b_ret = getb_ret();
							if (!b_ret || b_ret.length == 0 || b_ret[0]==undefined)
								return;
							$('#textQno2').val(b_ret[0].noa);
						}
						break;
					case q_name + '_s':
						q_boxClose2(s2);
						break;
				}
				b_pop = '';
			}

			var focus_addr = '', zip_fact = '';
			var z_cno = r_cno, z_acomp = r_comp, z_nick = r_comp.substr(0, 2);
			var carnoList = [];
			var thisCarSpecno = '';
			var ordcoverrate = [],rc2soverrate = [];
			var q1_weight=0,q2_weight=0;
			function q_gtPost(t_name) {
				switch (t_name) {
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
					case 'cont_btnOk':
						var as = _q_appendData("cont", "", true);
						var qno1_exists=(emp($('#textQno1').val())?true:false);
						var qno2_exists=(emp($('#textQno2').val())?true:false);
						var qtgg1='',qtgg2='';
						for ( i = 0; i < as.length; i++) {
							if(as[i].noa==$('#textQno1').val()){
								qno1_exists=true;
								q1_weight=dec(as[i].ordeweight);
								qtgg1=trim(as[i].tggno);
							}
							if(as[i].noa==$('#textQno2').val()){
								qno2_exists=true;
								q2_weight=dec(as[i].ordeweight);
								qtgg2=trim(as[i].tggno);
							}
						}
						
						if (!qno1_exists || !qno2_exists) {
							var t_qno='';
							if(!qno1_exists)
								t_qno=$('#textQno1').val();
							if(!qno2_exists)
								t_qno=t_qno+(t_qno.length>0?',':'')+$('#textQno2').val();
							alert(t_qno+'合約號碼不存在!!');
						}else if((!emp($('#textQno1').val()) && qtgg1!=trim($('#txtTggno').val())) || (!emp($('#textQno2').val()) && qtgg2!=trim($('#txtTggno').val()))){
							alert('合約廠商與進貨廠商不同!!');
						}else{
							var t_where = "where=^^ (1=0 "+(!emp($('#textQno1').val())?" or charindex('"+$('#textQno1').val()+"',transtart)>0 ":'')+(!emp($('#textQno2').val())?" or charindex('"+$('#textQno2').val()+"',transtart)>0 ":'')+ ") and noa!='"+$('#txtNoa').val()+"' ^^";
							q_gt('view_rc2', t_where, 0, 0, 0, "cont_view_rc2", r_accy);
						}
						break;
					case 'cont_view_rc2':
						var as = _q_appendData("view_rc2", "", true);
						for ( i = 0; i < as.length; i++) {
							var t_quat=as[i].transtart.split('##');
							if(t_quat[0]!=undefined){
								var r_quat=t_quat[0].split('@');
								if(r_quat[0]==$('#textQno1').val()){
									q1_weight=q_sub(q1_weight,dec(r_quat[1]));
								}
								if(r_quat[0]==$('#textQno2').val()){
									q2_weight=q_sub(q2_weight,dec(r_quat[1]));
								}
							}
							if(t_quat[1]!=undefined){
								var r_quat=t_quat[1].split('@');
								if(r_quat[0]==$('#textQno1').val()){
									q1_weight=q_sub(q1_weight,dec(r_quat[1]));
								}
								if(r_quat[0]==$('#textQno2').val()){
									q2_weight=q_sub(q2_weight,dec(r_quat[1]));
								}
							}
						}
						if(q1_weight>=dec($('#textQweight1').val()) && q2_weight>=dec($('#textQweight2').val()) ){
							check_cont=true;
							btnOk();
						}else{
							var t_err='';
							if(q1_weight<dec($('#textQweight1').val()))
								t_err+='合約號碼【'+$('#textQno1').val()+'】合約剩餘重量'+FormatNumber(q1_weight)+'小於進貨重量'+FormatNumber($('#textQweight1').val());
							if(q2_weight<dec($('#textQweight2').val()))
								t_err+=(t_err.length>0?'\n':'')+'合約號碼【'+$('#textQno2').val()+'】合約剩餘重量'+FormatNumber(q2_weight)+'小於進貨重量'+FormatNumber($('#textQweight2').val());
							alert(t_err);
						}
						q1_weight=0,q2_weight=0;
						break;
					case 'btnOk_uccb':
						var as = _q_appendData("view_uccb", "", true);
                        if (as[0] != undefined) {
                        	var t_uno='';
                        	for ( i = 0; i < as.length; i++) {
                        		t_uno=((t_uno.length>0)?',':'')+as[i].uno;
                        	}
                            alert(t_uno+"批號已存在!!");
                        }else{
                        	check_uccb_uno=true;
                        	btnOk();
                        }
                        break;
					case 'getuno':
						var as = _q_appendData("view_uccb", "", true);
						var maxnoq=0; 
						if(as[0] != undefined){
							maxnoq=dec(as[0].uno.slice(-3));
						}
						
						//判斷表身批號是否已被使用
						for (var j = 0; j < (q_bbsCount == 0 ? 1 : q_bbsCount); j++) {
							if(replaceAll($('#txtDatea').val(),'/','')+(('000'+maxnoq).slice(-3))==$('#txtUno_'+j).val() && !emp($('#txtUno_'+j).val())){
								maxnoq=maxnoq+1;
							}
						}
						
						//寫入批號
						for (var j = 0; j < (q_bbsCount == 0 ? 1 : q_bbsCount); j++) {
							if(!emp($('#txtStyle_'+j).val()) && emp($('#txtUno_'+j).val())){
								maxnoq=maxnoq+1;
								$('#txtUno_'+j).val(replaceAll($('#txtDatea').val(),'/','')+(('000'+maxnoq).slice(-3)));
							}
						}
						
						get_maxuno=true;
						btnOk();
						break;
					case 'getCardealCarno' :
						var as = _q_appendData("cardeals", "", true);
						carnoList = as;
						var t_item = " @ ";
						if (as[0] != undefined) {
							for ( i = 0; i < as.length; i++) {
								t_item = t_item + (t_item.length > 0 ? ',' : '') + as[i].carno + '@' + as[i].carno;
							}
						}
						for(var k=0;k<carnoList.length;k++){
							if(carnoList[k].carno==$('#txtCarno').val()){
								thisCarSpecno = carnoList[k].carspecno;
								break;
							}
						}
						document.all.combCarno.options.length = 0;
						q_cmbParse("combCarno", t_item);
						$('#combCarno').unbind('change').change(function(){
							if (q_cur == 1 || q_cur == 2) {
								$('#txtCarno').val($('#combCarno').find("option:selected").text());
							}
							for(var k=0;k<carnoList.length;k++){
								if(carnoList[k].carno==$('#txtCarno').val()){
									thisCarSpecno = carnoList[k].carspecno;
									break;
								}
							}
						});
						break;
					case 'cno_acomp':
						var as = _q_appendData("acomp", "", true);
						if (as[0] != undefined) {
							z_cno = as[0].noa;
							z_acomp = as[0].acomp;
							z_nick = as[0].nick;
						}
						break;
					case 'custaddr':
						var as = _q_appendData("custaddr", "", true);
						var t_item = " @ ";
						if (as[0] != undefined) {
							for ( i = 0; i < as.length; i++) {
								t_item = t_item + (t_item.length > 0 ? ',' : '') + as[i].post + '@' + as[i].addr;
							}
						}
						document.all.combAddr.options.length = 0;
						q_cmbParse("combAddr", t_item);
						break;
					case 'tgg':
						var as = _q_appendData("tgg", "", true);
						if (as[0] != undefined && focus_addr != '') {
							$('#' + zip_fact).val(as[0].zip_fact);
							$('#' + focus_addr).val(as[0].addr_fact);
							zip_fact = '';
							focus_addr = '';
						}
						break;
					case 'cust':
						var as = _q_appendData("cust", "", true);
						if (as[0] != undefined && focus_addr != '') {
							$('#' + zip_fact).val(as[0].zip_fact);
							$('#' + focus_addr).val(as[0].addr_fact);
							zip_fact = '';
							focus_addr = '';
						}
						break;
					case 'btnDele':
						var as = _q_appendData("pays", "", true);
						if (as[0] != undefined) {
							var t_msg = "", t_paysale = 0;
							for (var i = 0; i < as.length; i++) {
								t_paysale = parseFloat(as[i].paysale.length == 0 ? "0" : as[i].paysale);
								if (t_paysale != 0)
									t_msg += String.fromCharCode(13) + '付款單號【' + as[i].noa + '】 ' + FormatNumber(t_paysale);
							}
							if (t_msg.length > 0) {
								alert('已沖帳:' + t_msg);
								Unlock(1);
								return;
							}
						}
						_btnDele();
						Unlock(1);
						break;
					case 'btnModi':
						var as = _q_appendData("pays", "", true);
						if (as[0] != undefined) {
							var t_msg = "", t_paysale = 0;
							for (var i = 0; i < as.length; i++) {
								t_paysale = parseFloat(as[i].paysale.length == 0 ? "0" : as[i].paysale);
								if (t_paysale != 0)
									t_msg += String.fromCharCode(13) + '付款單號【' + as[i].noa + '】 ' + FormatNumber(t_paysale);
							}
							if (t_msg.length > 0) {
								alert('已沖帳:' + t_msg);
								Unlock(1);
								return;
							}
						}
						_btnModi();
						Unlock(1);
						$('#txtDatea').focus();
						if (!emp($('#txtTggno').val())) {
							var t_where = "where=^^ noa='" + $('#txtTggno').val() + "' group by post,addr^^";
							q_gt('custaddr', t_where, 0, 0, 0, "");
						}
						break;
					case 'ordc':
						var ordc = _q_appendData("ordc", "", true);
						if (ordc[0] != undefined) {
							$('#combPaytype').val(ordc[0].paytype);
							$('#txtPaytype').val(ordc[0].pay);
							$('#cmbTrantype').val(ordc[0].trantype);
							$('#txtPost2').val(ordc[0].post2);
							$('#txtAddr2').val(ordc[0].addr2);
						}
						break;
					case 'startdate':
						var as = _q_appendData('tgg', '', true);
						var t_startdate='';
						if (as[0] != undefined) {
							t_startdate=as[0].startdate;
						}
						if(t_startdate.length==0 || ('00'+t_startdate).slice(-2)=='00' || $('#txtDatea').val().substr(r_lenm+1, 2)<('00'+t_startdate).substr(-2)){
							$('#txtMon').val($('#txtDatea').val().substr(0, r_lenm));
						}else{
							var t_date=$('#txtDatea').val();
							var nextdate='';
							if(r_len==4)
								nextdate=new Date(dec(t_date.substr(0,4))+1911,dec(t_date.substr(5,2))-1,dec(t_date.substr(8,2)));
							else
								nextdate=new Date(dec(t_date.substr(0,3))+1911,dec(t_date.substr(4,2))-1,dec(t_date.substr(7,2)));
				    		nextdate.setMonth(nextdate.getMonth() +1)
				    		if(r_len==4)
				    			t_date=''+(nextdate.getFullYear())+'/'+(nextdate.getMonth()<9?'0':'')+(nextdate.getMonth()+1);
				    		else
				    			t_date=''+(nextdate.getFullYear()-1911)+'/'+(nextdate.getMonth()<9?'0':'')+(nextdate.getMonth()+1);
							$('#txtMon').val(t_date);
						}
						check_startdate=true;
						btnOk();
						break;
					case q_name:
						if (q_cur == 4)
							q_Seek_gtPost();
						break;
				}
			}

			function q_stPost() {
				if (!(q_cur == 1 || q_cur == 2))
					return false;
				var s1 = xmlString.split(';');
				abbm[q_recno]['accno'] = s1[0];
				$('#txtAccno').val(s1[0]);
				if((!emp($('#textQno1').val()) || !emp($('#textQno2').val())))
					q_func('qtxt.query.changecontgweight', 'rc2.txt,changecont_vu,' + encodeURI(r_accy) + ';' + encodeURI($('#txtNoa').val()));
			}
			
			var check_startdate=false;
			var check_uccb_uno=false;
			var get_uno=false,get_maxuno=false;
			var check_cont=false;
			function btnOk() {
				var t_err = q_chkEmpField([['txtNoa', q_getMsg('lblNoa')],['txtDatea', q_getMsg('lblDatea')], ['txtTggno', q_getMsg('lblTgg')], ['txtCno', q_getMsg('lblAcomp')]]);
				// 檢查空白
				if (t_err.length > 0) {
					alert(t_err);
					return;
				}
				
				if((!emp($('#textQno1').val()) || !emp($('#textQno2').val())) && dec($('#txtWeight').val())!=q_add(dec($('#textQweight1').val()),dec($('#textQweight2').val()))){
					alert('合約重量'+FormatNumber(q_add(dec($('#textQweight1').val()),dec($('#textQweight2').val())))+'不等於進貨淨重'+FormatNumber(dec($('#txtWeight').val()))+'!!');
					return;
				}
				
				if((!emp($('#textQno1').val()) && !emp($('#textQno2').val())) && $('#textQno1').val()==$('#textQno2').val() ){
					alert('合約1號碼與合約2號碼相同!!');
					return;
				}
				
				//判斷起算日,寫入帳款月份
				if(!check_startdate&&emp($('#txtMon').val())){
					var t_where = "where=^^ noa='"+$('#txtTggno').val()+"' ^^";
					q_gt('tgg', t_where, 0, 0, 0, "startdate", r_accy);
					return;
				}
				
				//檢查合約是否存在或已結案
				if(!check_cont && (!emp($('#textQno1').val()) || !emp($('#textQno2').val()))){
					var t_where = "where=^^ 1=0 "+(!emp($('#textQno1').val())?" or noa='"+$('#textQno1').val()+"' ":'')+(!emp($('#textQno2').val())?" or noa='"+$('#textQno2').val()+"' ":'')+ " ^^";
					q_gt('cont', t_where, 0, 0, 0, "cont_btnOk", r_accy);
					return;
				}
				
				//判斷批號是否已使用
				/*if(!check_uccb_uno){
                	var t_uno = "1=0";
                    for (var i = 0; i < q_bbsCount; i++) {
                        if ($.trim($('#txtUno_' + i).val()).length > 0)
                            t_uno += " or uno='" + $.trim($('#txtUno_' + i).val()) + "'";
                    }
					var t_where = "where=^^ ("+t_uno+") and noa!='"+$('#txtNoa').val()+"' ^^";
					q_gt('view_uccb', t_where, 0, 0, 0, "btnOk_uccb", r_accy);
					return;
                }*/
				
				//產生批號當天最大批號數
				//判斷是否要產生批號
				/*if(!get_uno){
					for (var j = 0; j < (q_bbsCount == 0 ? 1 : q_bbsCount); j++) {
						if(!emp($('#txtStyle_'+j).val()) && emp($('#txtUno_'+j).val())){
							get_uno=true;
							break;
						}
					}
				}
				
				if(get_uno && !get_maxuno){
					var t_where = "where=^^ uno=isnull((select MAX(uno) from view_uccb where uno like '"+replaceAll($('#txtDatea').val(),'/','')+"%' and len(uno)=11),'')  and uno!='' ^^";
					q_gt('view_uccb', t_where, 0, 0, 0, "getuno", r_accy);
					return;
				}*/
				
				check_uccb_uno=false;
				check_startdate=false;
				get_uno=false;
				get_maxuno=false;
				check_cont=false;
				
				$('#txtTranstart').val($('#textQno1').val()+'@'+dec($('#textQweight1').val())+'##'+$('#textQno2').val()+'@'+dec($('#textQweight2').val()));
				
				sum();
				
				if (q_cur == 1)
					$('#txtWorker').val(r_name);
				if (q_cur == 2)
					$('#txtWorker2').val(r_name);
					
				var s1 = $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val();
				if (s1.length == 0 || s1 == "AUTO")
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_rc2') + $('#txtDatea').val(), '/', ''));
				else
					wrServer(s1);
			}

			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)// 1-3
					return;
				q_box('rc2_vu_s.aspx', q_name + '_s', "500px", "520px", q_getMsg("popSeek"));
			}

			function cmbPaytype_chg() {
				var cmb = document.getElementById("combPaytype");
				if (!q_cur)
					cmb.value = '';
				else
					$('#txtPaytype').val(cmb.value);
				cmb.value = '';
			}

			function combAddr_chg() {
				if (q_cur == 1 || q_cur == 2) {
					$('#txtAddr2').val($('#combAddr').find("option:selected").text());
					$('#txtPost2').val($('#combAddr').find("option:selected").val());
				}
			}

			function bbsAssign() {
				for (var j = 0; j < (q_bbsCount == 0 ? 1 : q_bbsCount); j++) {
					if (!$('#btnMinus_' + j).hasClass('isAssign')) {
						$('#btnMinus_' + j).click(function() {
							btnMinus($(this).attr('id'));
						});
						
						$('#txtUnit_' + j).focusout(function() {
							if (q_cur == 1 || q_cur == 2)
								sum();
						});
						
						$('#txtMount_' + j).focusout(function() {
							if (q_cur == 1 || q_cur == 2)
								sum();
						});
						
						$('#txtWeight_' + j).focusout(function() {
							if (q_cur == 1 || q_cur == 2)
								sum();
						});
						
						$('#txtPrice_' + j).focusout(function() {
							if (q_cur == 1 || q_cur == 2)
								sum();
						});
						
						$('#txtTotal_' + j).focusout(function() {
							sum();
						});
						
						$('#btnRecord_' + j).click(function() {
							var n = replaceAll($(this).attr('id'), 'btnRecord_', '');
							q_box("z_rc2record.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";tgg=" + $('#txtTggno').val() + "&product=" + $('#txtProductno_' + n).val() + ";" + r_accy, 'z_vccstp', "95%", "95%", q_getMsg('popPrint'));
						});
						
						$('#combUcolor_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtUcolor_'+b_seq).val($('#combUcolor_'+b_seq).find("option:selected").text());
						});
						
						$('#combSpec_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtSpec_'+b_seq).val($('#combSpec_'+b_seq).find("option:selected").text());
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
						
						$('#txtSize_' + j).change(function() {
							 if ($(this).val().substr(0, 1) != '#')
                        		$(this).val('#' + $(this).val());
						});
					}
				}
				_bbsAssign();
				refreshBbm();
				HiddenTreat();
				$('#div_orde').hide();
				$('#lblNoq_s').text('項序');
				$('#lblProductno_s').text('品號');
				$('#lblProduct_s').text('品名');
				$('#lblUcolor_s').text('類別');
				$('#lblStyle_s').text('型');
				$('#lblSpec_s').text('材質');
				$('#lblSize_s').text('號數');
				$('#lblLengthb_s').text('米數');
				$('#lblClass_s').text('廠牌');
				$('#lblMount_s').text('數量(件)');
				$('#lblWeight_s').text('重量(KG)');
				
			}

			function btnIns() {
				_btnIns();
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val('AUTO');
				$('#txtCno').val(z_cno);
				$('#txtAcomp').val(z_acomp);
				$('#txtDatea').val(q_date());
				$('#txtDatea').focus();
				$('#cmbTaxtype').val(1);
				var t_where = "where=^^ 1=1 group by post,addr^^";
				q_gt('custaddr', t_where, 0, 0, 0, "");
			}

			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				Lock(1, {
					opacity : 0
				});
				//取得車號下拉式選單
				var thisVal = $('#txtCardealno').val();
				var t_where = "where=^^ noa=N'" + thisVal + "' ^^";
				q_gt('cardeal', t_where, 0, 0, 0, "getCardealCarno");
				var t_where = " where=^^ rc2no='" + $('#txtNoa').val() + "'^^";
				q_gt('pays', t_where, 0, 0, 0, 'btnModi', r_accy);
			}

			function btnPrint() {
				//q_box("z_rc2p_vu.aspx?;;;noa=" + trim($('#txtNoa').val()) + ";" + r_accy, '', "95%", "95%", q_getMsg("popPrint"));
			}

			function wrServer(key_value) {
				var i;
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
			}

			function bbsSave(as) {
				if (!as['productno'] && !as['product'] && !as['spec'] && !dec(as['total'])) {
					as[bbsKey[1]] = '';
					return;
				}
				q_nowf();
				as['type'] = abbm2['type'];
				as['mon'] = abbm2['mon'];
				as['noa'] = abbm2['noa'];
				as['datea'] = abbm2['datea'];
				as['tggno'] = abbm2['tggno'];
				as['kind'] = abbm2['kind'];
				if (abbm2['storeno'])
					as['storeno'] = abbm2['storeno'];
				t_err = '';
				if (as['price'] != null && (dec(as['price']) > 99999999 || dec(as['price']) < -99999999))
					t_err = q_getMsg('msgPriceErr') + as['price'] + '\n';
				if (as['total'] != null && (dec(as['total']) > 999999999 || dec(as['total']) < -99999999))
					t_err = q_getMsg('msgMoneyErr') + as['total'] + '\n';
				if (t_err) {
					alert(t_err);
					return false;
				}
				return true;
			}

			function refresh(recno) {
				_refresh(recno);
				refreshBbm();
				HiddenTreat();
				$('#div_orde').hide();
			}

			function readonly(t_para, empty) {
				_readonly(t_para, empty);
				if (t_para) {
					$('#combAddr').attr('disabled', 'disabled');
				} else {
					$('#combAddr').removeAttr('disabled');
				}
				
				//限制帳款月份的輸入 只有在備註的第一個字為*才能手動輸入
				if ($('#txtMemo').val().substr(0,1)=='*')
					$('#txtMon').removeAttr('readonly');
				else
					$('#txtMon').attr('readonly', 'readonly');
				refreshBbm();
				HiddenTreat();
			}

			function btnMinus(id) {
				_btnMinus(id);
				sum();
			}

			function btnPlus(org_htm, dest_tag, afield) {
				_btnPlus(org_htm, dest_tag, afield);
				if (q_tables == 's')
					bbsAssign();
			}

			function q_appendData(t_Table) {
				dataErr = !_q_appendData(t_Table);
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
				Lock(1, {
					opacity : 0
				});
				var t_where = " where=^^ rc2no='" + $('#txtNoa').val() + "'^^";
				q_gt('pays', t_where, 0, 0, 0, 'btnDele', r_accy);
			}

			function btnCancel() {
				_btnCancel();
			}

			function q_popPost(s1) {
				switch (s1) {
					case 'txtCardealno':
						//取得車號下拉式選單
						var thisVal = $('#txtCardealno').val();
						var t_where = "where=^^ noa=N'" + thisVal + "' ^^";
						q_gt('cardeal', t_where, 0, 0, 0, "getCardealCarno");
						break;
					case 'txtTggno':
						if (!emp($('#txtTggno').val())) {
							var t_where = "where=^^ noa='" + $('#txtTggno').val() + "' ^^";
							q_gt('custaddr', t_where, 0, 0, 0, "");
						}
						break;
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
			
			function q_funcPost(t_func, result) {
				switch(t_func) {
					case 'changecontgweight':
						break;
					case 'qtxt.query.rc2toorde':
						var as = _q_appendData("tmp0", "", true, true);
						if (as[0] != undefined) {
							if(as[0].t_err=='modi'){
								alert('訂單已更新!!');
							}
							if(as[0].t_err=='modi'){
								alert('訂單已產生!!');
							}
							$('#txtOrdeno').val(as[0].ordeno);
							abbm[q_recno]['ordeno']=as[0].ordeno;
						}else{
							alert('訂單產生錯誤!!');
						}
						
						$('#btnOk_div_orde').removeAttr('disabled').val('轉訂單');
						$('#div_orde').hide();
						break;
				}
			}
		</script>
		<style type="text/css">
			#dmain {
				overflow: hidden;
			}
			.dview {
				float: left;
				width: 30%;
				border-width: 0px;
			}
			.tview {
				width: 100%;
				margin: 0;
				padding: 2px;
				border: 1px black double;
				border-spacing: 0;
				font-size: medium;
				background-color: #FFFF66;
				color: blue;
			}
			.tview td {
				padding: 2px;
				text-align: center;
				border: 1px black solid;
			}
			.dbbm {
				float: left;
				width: 70%;
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
			.tbbm .tdZ {
				width: 2%;
			}
			.tbbm tr td span {
				float: right;
				display: block;
				width: 5px;
				height: 10px;
			}
			.tbbm tr td .lbl {
				float: right;
				color: blue;
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
			.txt.c2 {
				width: 38%;
				float: left;
			}
			.txt.c3 {
				width: 60%;
				float: left;
			}
			.txt.c6 {
				width: 25%;
			}
			.txt.ime {
				ime-mode:disabled;
				-webkit-ime-mode: disabled;
				-moz-ime-mode:disabled;
				-o-ime-mode:disabled;
				-ms-ime-mode:disabled;
			}
			.txt.num {
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
			.tbbm select {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
				font-size: medium;
			}
			.tbbm td {
				width: 9%;
			}
			input[type="text"], input[type="button"] ,select{
				font-size: medium;
			}
			.dbbs .tbbs {
				margin: 0;
				padding: 2px;
				border: 2px lightgrey double;
				border-spacing: 1px;
				border-collapse: collapse;
				font-size: medium;
				color: blue;
				background: #cad3ff;
				width: 100%;
			}
			.dbbs .tbbs tr {
				height: 35px;
			}
			.dbbs .tbbs tr td {
				text-align: center;
				border: 2px lightgrey double;
			}

		</style>
	</head>
	<body>
		<!--#include file="../inc/toolbar.inc"-->
		<div id='dmain' style="overflow:hidden; width: 100%;">
			<div class="dview" id="dview">
				<table class="tview" id="tview" >
					<tr>
						<td align="center" style="width:5%"><a id='vewChk'> </a></td>
						<td align="center" style="width:5%"><a id='vewTypea'> </a></td>
						<td align="center" style="width:25%"><a id='vewDatea'> </a></td>
						<td align="center" style="width:25%"><a id='vewNoa'> </a></td>
						<td align="center" style="width:40%"><a id='vewTgg'> </a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" style=''/></td>
						<td align="center" id='typea=rc2.typea'>~typea=rc2.typea</td>
						<td align="center" id='datea'>~datea</td>
						<td align="center" id='noa'>~noa</td>
						<td align="center" id='tggno tgg,4' style="text-align: left;">~tggno ~tgg,4</td>
					</tr>
				</table>
			</div>
			<div class='dbbm'>
				<table class="tbbm" id="tbbm">
					<tr>
						<td><span> </span><a id='lblType' class="lbl"> </a></td>
						<td>
							<input id="txtType" type="text" style='display:none;'/>
							<select id="cmbTypea" class="txt c1"> </select>
						</td>
						<td><span> </span><a id='lblStype' class="lbl"> </a></td>
						<td><select id="cmbStype" class="txt c1"> </select></td>
						<td><span> </span><a id='lblDatea' class="lbl"> </a></td>
						<td><input id="txtDatea" type="text" class="txt c1 ime"/></td>
						<td><span> </span><a id='lblNoa' class="lbl"> </a></td>
						<td><input id="txtNoa" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblAcomp' class="lbl btn"> </a></td>
						<td><input id="txtCno" type="text" class="txt c1"/></td>
						<td colspan="2"><input id="txtAcomp" type="text" class="txt c1"/></td>
						<td ><span> </span><a id='lblMon' class="lbl"> </a></td>
						<td><input id="txtMon" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblInvono' class="lbl btn"> </a></td>
						<td><input id="txtInvono" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblTgg' class="lbl btn"> </a></td>
						<td><input id="txtTggno" type="text" class="txt c1" /></td>
						<td colspan="2"><input id="txtTgg" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblTel' class="lbl"> </a></td>
						<td><input id="txtTel" type="text" class="txt c1"/></td>
						<!--<td><span> </span><a id='lblOrdc' class="lbl btn"> </a></td>
						<td><input id="txtOrdcno" type="text" class="txt c1"/></td>-->
					</tr>
					<tr>
						<td><span> </span><a id='lblAddr' class="lbl btn"> </a></td>
						<td><input id="txtPost" type="text" class="txt c1"/></td>
						<td colspan='4' ><input id="txtAddr" type="text" class="txt" style="width: 98%;"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblAddr2' class="lbl btn"> </a></td>
						<td><input id="txtPost2" type="text" class="txt c1"/></td>
						<td colspan='4' >
							<input id="txtAddr2" type="text" class="txt" style="width: 95%;"/>
							<select id="combAddr" style="width: 20px" onchange='combAddr_chg()'> </select>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id='lblTranadd' class="lbl"> </a></td>
						<td colspan="2"><input id="txtTranadd" type="text" class="txt num c1"/></td>
						<td><span> </span><a id='lblBenifit' class="lbl"> </a></td>
						<td colspan="2"><input id="txtBenifit" type="text" class="txt num c1"/></td>
						<td><span> </span><a id='lblWeight' class="lbl"> </a></td>
						<td><input id="txtWeight" type="text" class="txt num c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblPaytype' class="lbl"> </a></td>
						<td><input id="txtPaytype" type="text" class="txt c1"/></td>
						<td><select id="combPaytype" class="txt c1" onchange='cmbPaytype_chg()'> </select></td>
						<td><span> </span><a id='lblTrantype' class="lbl"> </a></td>
						<td colspan="2"><select id="cmbTrantype" class="txt c1"> </select></td>
						<td><span> </span><a id='lblAccc' class="lbl btn"> </a></td>
						<td><input id="txtAccno" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblCardeal' class="lbl btn"> </a></td>
						<td><input id="txtCardealno" type="text" class="txt c1"/></td>
						<td><input id="txtCardeal" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblCarno' class="lbl"> </a></td>
						<td>
							<input id="txtCarno" type="text" class="txt" style="width:75%;"/>
							<select id="combCarno" style="width: 20%;"> </select>
						</td>
						<td><!--<select id="cmbTranstyle" style="width: 100%;"> </select>--></td>
						<td><span> </span><a id='lblTranmoney' class="lbl"> </a></td>
						<td><input id="txtTranmoney" type="text" class="txt num c1" /></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblMoney' class="lbl"> </a></td>
						<td colspan='2'>
							<input id="txtMoney" type="text" class="txt num c1" />
						</td>
						<td ><span> </span><a id='lblTax' class="lbl"> </a></td>
						<td colspan='2' >
							<input id="txtTax" type="text" class="txt num c1 istax" style="width: 49%;" />
							<!--<select id="cmbTaxtype" class="txt c1" style="width: 49%;" onchange="calTax();"> </select>-->
							<input id="chkAtax" type="checkbox" />
						</td>
						<td><span> </span><a id='lblTotal' class="lbl istax"> </a></td>
						<td><input id="txtTotal" type="text" class="txt num c1 istax" /></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblMemo' class="lbl"> </a></td>
						<td colspan='7' >
							<input id="txtMemo" type="text" class="txt" style="width:98%;"/>
							<input id="txtTranstart" type="hidden"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id="lblQno1" class="lbl btn">合約1號碼</a></td>
						<td colspan='2'><input id="textQno1" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblQweight1" class="lbl">合約1重量</a></td>
						<td colspan='2'><input id="textQweight1" type="text" class="txt num c1"  style="width:70%;"/>&nbsp; KG</td>
						<td><span> </span><a id='lblWorker' class="lbl"> </a></td>
						<td><input id="txtWorker" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblQno2" class="lbl btn">合約2號碼</a></td>
						<td colspan='2'><input id="textQno2" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblQweight2" class="lbl">合約2重量</a></td>
						<td colspan='2'><input id="textQweight2" type="text" class="txt num c1" style="width:70%;"/>&nbsp; KG</td>
						<td><span> </span><a id='lblWorker2' class="lbl"> </a></td>
						<td><input id="txtWorker2" type="text" class="txt c1"/></td>
					</tr>
				</table>
			</div>
		</div>
		<div class='dbbs' style="width: 100%;"><!--2100px-->
			<table id="tbbs" class='tbbs' border="1" cellpadding='2' cellspacing='1' >
				<tr style='color:White; background:#003366;' >
					<td align="center" style="width:1%;"><input class="btn" id="btnPlus" type="button" value='＋' style="font-weight: bold;" /></td>
					<td align="center" style="width:55px;"><a id='lblNoq_s'> </a></td>
					<!--<td align="center" style="width:180px;"><a id='lblUno_s'> </a></td>-->
					<!--<td align="center" style="width:150px;"><a id='lblProductno_s'> </a></td>-->
					<td align="center" style="width:150px;"><a id='lblProduct_s'> </a></td>
					<td align="center" style="width:160px;"><a id='lblUcolor_s'> </a></td>
					<td align="center" style="width:40px;"><a id='lblStyle_s'> </a></td>
					<td align="center" style="width:150px;"><a id='lblSpec_s'> </a></td>
					<td align="center" style="width:100px;"><a id='lblSize_s'> </a></td>
					<td align="center" style="width:100px;"><a id='lblLengthb_s'> </a></td>
					<td align="center" style="width:150px;"><a id='lblClass_s'> </a></td>
					<!--<td align="center" style="width:40px;"><a id='lblUnit_s'> </a></td>-->
					<td align="center" style="width:90px;"><a id='lblMount_s'> </a></td>
					<td align="center" style="width:90px;"><a id='lblWeight_s'> </a></td>
					<td align="center" style="width:90px;"><a id='lblPrice_s'> </a></td>
					<td align="center" style="width:100px;"><a id='lblTotal_s'> </a></td>
					<td align="center" style="width:180px;"><a id='lblStore_s'> </a></td>
					<td align="center" style="width:180px;"><a id='lblMemo_s'> </a></td>
					<!--<td align="center" style="width:60px;"><a id='lblRecord_s'> </a></td>-->
				</tr>
				<tr style='background:#cad3ff;'>
					<td><input class="btn" id="btnMinus.*" type="button" value='－' style=" font-weight: bold;" /></td>
					<td><input id="txtNoq.*" type="text" class="txt c1"/></td>
					<!--<td><input id="txtUno.*" type="text" class="txt c1"/></td>-->
					<!--<td>
						<input id="txtProductno.*" type="text" class="txt c1" style="width: 83%;"/>
						<input class="btn" id="btnProductno.*" type="button" value='.' style="font-weight: bold;" />
					</td>-->
					<td>
						<input id="txtProduct.*" type="text" class="txt c1" style="width: 70%;"/>
						<select id="combProduct.*" class="txt" style="width: 20px;"> </select>
					</td>
					<td>
						<input id="txtUcolor.*" type="text" class="txt c1" style="width: 110px;"/>
						<select id="combUcolor.*" class="txt" style="width: 20px;"> </select>
					</td>
					<td><input id="txtStyle.*" type="text" class="txt c1"/></td>
					<td>
						<input id="txtSpec.*" type="text" class="txt c1" style="width: 70%;"/>
						<select id="combSpec.*" class="txt" style="width: 20px;"> </select>
					</td>
					<td><input id="txtSize.*" type="text" class="txt c1" /></td>
					<td><input id="txtLengthb.*" type="text" class="txt num c1" /></td>
					<td>
						<input id="txtClass.*" type="text" class="txt c1" style="width: 70%;"/>
						<select id="combClass.*" class="txt" style="width: 20px;"> </select>
					</td>
					<!--<td><input id="txtUnit.*" type="text" class="txt c1"/></td>-->
					<td><input id="txtMount.*" type="text" class="txt num c1" /></td>
					<td><input id="txtWeight.*" type="text" class="txt num c1" /></td>
					<td><input id="txtPrice.*" type="text" class="txt num c1" /></td>
					<td><input id="txtTotal.*" type="text" class="txt num c1" /></td>
					<td>
						<input id="txtStoreno.*" type="text" class="txt c1" style="width: 65%;"/>
						<input class="btn" id="btnStoreno.*" type="button" value='.' style=" font-weight: bold;float: left;" />
						<input id="txtStore.*" type="text" class="txt c1"/>
					</td>
					<td>
						<input id="txtMemo.*" type="text" class="txt c1"/>
						<!--<input id="txtOrdeno.*" type="text" class="txt" style="width:68%;" />
						<input id="txtNo2.*" type="text" class="txt" style="width:25%;" />-->
						<input id="recno.*" style="display:none;"/>
					</td>
					<!--<td align="center"><input class="btn" id="btnRecord.*" type="button" value='.' style=" font-weight: bold;" /></td>-->
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>