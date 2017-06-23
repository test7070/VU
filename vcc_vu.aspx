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
 
			q_tables = 't';
			var q_name = "vcc";
			var q_readonly = ['txtNoa', 'txtAccno', 'txtComp','txtCardeal','txtSales', 'txtAcomp', 'txtMoney', 'txtTotal', 'txtWorker', 'txtWorker2'];
			var q_readonlys = ['txtOrdeno', 'txtNo2','txtNoq'];
			var q_readonlyt = ['txtMount','txtWeight','txtProduct','txtUcolor','txtSpec','txtSize','txtLengthb','txtClass'];//105/07/22表身除了批號其他全鎖
			var bbmNum = [];
			var bbsNum = [];
			var bbtNum = [];
			var bbmMask = [];
			var bbsMask = [];
			var bbtMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwCount2 = 13;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'datea';

			aPop = new Array(
				['txtCustno', 'lblCust', 'cust', 'noa,comp,nick,tel,fax,zip_home,addr_home,paytype,trantype,salesno,sales', 'txtCustno,txtComp,txtNick,txtTel,txtFax,txtPost,txtAddr,txtPaytype,cmbTrantype,txtSalesno,txtSales', 'cust_b.aspx'],
				['txtStoreno_', 'btnStoreno_', 'store', 'noa,store', 'txtStoreno_,txtStore_', 'store_b.aspx'],
				['txtCardealno', 'lblCardeal', 'cardeal', 'noa,comp', 'txtCardealno,txtCardeal', 'cardeal_b.aspx'],
				['txtCarno', 'lblCarno', 'cardeals', 'a.carno,a.noa,a.comp', '0txtCarno,txtCardealno,txtCardeal', 'cardeals_b.aspx'],
				['txtCno', 'lblAcomp', 'acomp', 'noa,acomp', 'txtCno,txtAcomp', 'acomp_b.aspx'],
				['txtSalesno', 'lblSales', 'sss', 'noa,namea', 'txtSalesno,txtSales', 'sss_b.aspx']
				//['txtPost', 'lblAddr', 'addr', 'post,addr', 'txtPost,txtAddr', 'addr_b.aspx'],
				//['txtPost2', 'lblAddr2', 'addr', 'post,addr', 'txtPost2,txtAddr2', 'addr_b.aspx'],
				//['txtPost', 'lblAddr', 'addr2', 'noa,post', 'txtPost,txtAddr', 'addr2_b.aspx'],
				//['txtPost2', 'lblAddr2', 'addr2', 'noa,post', 'txtPost2,txtAddr2', 'addr2_b.aspx'],
				//['txtUno__', '', 'view_uccc2', 'uno,uno,product,spec,size,lengthb,class,unit,emount,eweight'
            	//, '0txtUno__,txtUno__,txtProduct__,txtSpec__,txtSize__,txtLengthb__,txtClass__,txtUnit__,txtMount__,txtWeight__', 'uccc_seek_b2.aspx?;;;1=0', '95%', '60%']
				//['txtProductno_', 'btnProductno_', 'ucaucc', 'noa,product,unit,spec', 'txtProductno_,txtProduct_,txtUnit_,txtSpec_,txtUcolor_', 'ucaucc_b.aspx']
			);

			$(document).ready(function() {
				q_desc = 1;
				bbmKey = ['noa'];
				bbsKey = ['noa', 'noq'];
				bbtKey = ['noa', 'noq'];
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
			
			var t_cont1='#non',t_cont2='#non';
			function mainPost() {
				q_getFormat();
				bbmMask = [['txtDatea', r_picd], ['txtMon', r_picm],['txtPaydate','99:99']];
				q_mask(bbmMask);
				bbmNum = [['txtTranmoney', 11, 0, 1], ['txtMoney', 15, 0, 1], ['txtTax', 15, 0, 1],['txtTotal', 15, 0, 1]
				,['txtTranadd', 15, q_getPara('vcc.weightPrecision'), 1],['txtBenifit', 15, q_getPara('vcc.weightPrecision'), 1],['txtWeight', 15, q_getPara('vcc.weightPrecision'), 1]
				,['textQweight1', 15, q_getPara('vcc.weightPrecision'), 1],['textQweight2', 15, q_getPara('vcc.weightPrecision'), 1]
				,['txtPrice', 12, 3, 1]];
				bbsNum = [['txtPrice', 12, q_getPara('vcc.pricePrecision'), 1], ['txtMount', 9, q_getPara('vcc.mountPrecision'), 1], ['txtWeight', 9, q_getPara('vcc.weightPrecision'), 1], ['txtLengthb', 15, 2, 1], ['txtTotal', 15, 0, 1]];
				bbtNum = [['txtMount', 10, q_getPara('vcc.mountPrecision'), 1], ['txtWeight', 9, q_getPara('vcc.weightPrecision'), 1], ['txtLengthb', 15, 2, 1]];
				//q_cmbParse("cmbTranstyle", q_getPara('sys.transtyle'));
				q_cmbParse("cmbTypea", q_getPara('vcc.typea'));
				q_cmbParse("cmbStype", q_getPara('vcc.stype'));
				//q_cmbParse("cmbTaxtype", q_getPara('sys.taxtype'));
				q_cmbParse("combPay", q_getPara('vcc.paytype'));
				q_cmbParse("cmbTrantype", q_getPara('sys.tran'));
				//q_cmbParse("combUcolor", q_getPara('vccs_vu.typea'),'s');
				//q_cmbParse("combProduct", q_getPara('vccs_vu.product'),'s');
				//q_cmbParse("combProduct", q_getPara('vccs_vu.product'),'t');
				
				var t_where = "where=^^ 1=1 ^^";
				q_gt('ucc', t_where, 0, 0, 0, "");
				
				$('#lblPaydate').text('入廠時間');
				$('#lblAddr2').text('工地名稱');
				$('#lblTranadd').text('車空重');
				$('#lblBenifit').text('車總重');
				$('#lblWeight').text('淨重');
				$('#lblTranmoney').text('應付運費');
				
				$('#txtTranadd').change(function() {
					q_tr('txtWeight',q_sub(q_float('txtBenifit'),q_float('txtTranadd')))
					$('#txtTranmoney').val(round(q_mul(dec($('#txtPrice').val()),dec($('#txtWeight').val())),0))
				});
				
				$('#txtBenifit').change(function() {
					q_tr('txtWeight',q_sub(q_float('txtBenifit'),q_float('txtTranadd')))
					$('#txtTranmoney').val(round(q_mul(dec($('#txtPrice').val()),dec($('#txtWeight').val())),0))
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
				
				$('#txtCardealno').change(function(){
					//取得車號下拉式選單
					var thisVal = $(this).val();
					var t_where = "where=^^ noa=N'" + thisVal + "' ^^";
					q_gt('cardeal', t_where, 0, 0, 0, "getCardealCarno");
				});
				
				$('#btnOrdes').click(function() {
					var t_custno = trim($('#txtCustno').val());
					var t_where = '';
					if (t_custno.length > 0) {
						t_where = "isnull(notv,0)>0  && isnull(enda,0)!=1 && isnull(cancel,0)!=1 &&" + (t_custno.length > 0 ? q_sqlPara("custno", t_custno) : "");
						if (!emp($('#txtOrdeno').val()))
							t_where += " && charindex(noa,'" + $('#txtOrdeno').val() + "')>0";
						t_where = t_where;
					} else {
						alert(q_getMsg('msgCustEmp'));
						return;
					}
					q_box("ordes_vu_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'ordes', "95%", "650px", q_getMsg('popOrde'));
				});
				
				$('#btnPack').click(function() {
					t_where = '';
                	t_noa = $('#txtNoa').val();
                	if(t_noa.length > 0){
                		t_where = "noa='" + t_noa + "'";
                		q_box("packing_vu_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'pack', "870px", "95%", $('#btnPack').val());
                	}
				});

				$('#lblOrdeno').click(function() {
					q_pop('txtOrdeno', "orde_vu.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";charindex(noa,'" + $('#txtOrdeno').val() + "')>0;" + r_accy + '_' + r_cno, 'orde', 'noa', '', "92%", "1024px", '訂單作業', true);
				});
				
				$('#lblZipcode').click(function() {
					q_pop('txtZipcode', "quat_vu.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";charindex(noa,'" + $('#txtZipcode').val() + "')>0;" + r_accy + '_' + r_cno, 'quat', 'noa', '', "92%", "1024px", '出貨合約', true);
				});

				$('#lblAccc').click(function() {
					q_pop('txtAccno', "accc.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";accc3='" + $('#txtAccno').val() + "';" + $('#txtDatea').val().substring(0, 3) + '_' + r_cno, 'accc', 'accc3', 'accc2', "92%", "1054px", q_getMsg('lblAccc'), true);
				});

				$('#lblInvono').click(function() {
					t_where = '';
					t_invo = $('#txtInvono').val();
					if (t_invo.length > 0) {
						t_where = "noa='" + t_invo + "'";
						q_box("vcca.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'vcca', "95%", "95%", '開立發票');
					}
				});
				
				$('#cmbStype').change(function() {
					stype_chang();
				});
				
				$('#txtAddr').change(function() {
					var t_custno = trim($(this).val());
					if (!emp(t_custno)) {
						focus_addr = $(this).attr('id');
						var t_where = "where=^^ noa='" + t_custno + "' ^^";
						q_gt('cust', t_where, 0, 0, 0, "");
					}
				});

				$('#txtCustno').change(function() {
					/*if (!emp($('#txtCustno').val())) {
						var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' order by noq desc ^^";
						q_gt('custms', t_where, 0, 0, 0, "");
					}*/
				});
				
				$('#lblQno1').click(function() {
					var t_where="custno='"+$('#txtCustno').val()+"' and eweight>0 and isnull(enda,0)=0 ";
					if(q_cur==1 || q_cur==2)
						t_where=t_where+" and noa!='"+$('#textQno2').val()+"'";
					q_box("quat_vu_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'quat1_b', "800px", "700px", '出貨合約');
				});
				
				$('#textQno1').change(function() {
					if(!emp($('#textQno1').val())){
						var t_where="where=^^noa='"+$('#textQno1').val()+"'^^ ";
						q_gt('view_quat', t_where, 0, 0, 0, "qno1_chage", r_accy);
					}
				});
				
				$('#lblQno2').click(function() {
					var t_where="custno='"+$('#txtCustno').val()+"' and eweight>0 and isnull(enda,0)=0 ";
					if(q_cur==1 || q_cur==2)
						t_where=t_where+" and noa!='"+$('#textQno1').val()+"'";
					q_box("quat_vu_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'quat2_b', "800px", "700px", '出貨合約');
				});
				
				$('#textQno2').change(function() {
					if(!emp($('#textQno2').val())){
						var t_where="where=^^noa='"+$('#textQno2').val()+"'^^ ";
						q_gt('view_quat', t_where, 0, 0, 0, "qno2_chage", r_accy);
					}
				});
				
				$('#txtPaydate').focusin(function() {
					if($(this).val()=='AUTO'){
						$(this).val('');
					}
				});
				
				$('#txtWeight').change(function() {
					if(q_cur==1 || q_cur==2){
						$('#txtTranmoney').val(round(q_mul(dec($('#txtPrice').val()),dec($('#txtWeight').val())),0))
					}
				});
				$('#txtPrice').change(function() {
					if(q_cur==1 || q_cur==2){
						$('#txtTranmoney').val(round(q_mul(dec($('#txtPrice').val()),dec($('#txtWeight').val())),0))
					}
				});
			}
			
			function totalreadonly() { //1214小計開放修改
				for (var i = 0; i < q_bbsCount; i++) {
	                /*if (q_cur == 1 || q_cur==2) {
						if($('#txtProduct_'+i).val().indexOf('費')>-1)
							$('#txtTotal_'+i).css('color', 'black').css('background', 'white').removeAttr('readonly');  
						else
							$('#txtTotal_'+i).css('color', 'green').css('background', 'RGB(237,237,237)').attr('readonly', 'readonly');
	                }else{
	                	$('#txtTotal_'+i).css('color', 'green').css('background', 'RGB(237,237,237)').attr('readonly', 'readonly');
	                }*/
                }
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
                if (q_cur == 1) {
                    $('#txtNoa').css('color', 'black').css('background', 'white').removeAttr('readonly');
                } else {
                    $('#txtNoa').css('color', 'green').css('background', 'RGB(237,237,237)').attr('readonly', 'readonly');
                }
            }
            
            function refreshBbs() {
            	if(q_cur==1 || q_cur==2){
	            	for (var i = 0; i < q_bbsCount; i++) {
	            		if($('#txtItem_'+i).val()=='1'){
	            			$('#txtStoreno_'+i).attr('disabled', 'disabled');
	            			$('#btnStoreno_'+i).attr('disabled', 'disabled');
	            			$('#txtStore_'+i).attr('disabled', 'disabled');
	            		}else{
	            			$('#txtStoreno_'+i).removeAttr('disabled');
	            			$('#btnStoreno_'+i).removeAttr('disabled');
	            			$('#txtStore_'+i).removeAttr('disabled');
	            		}
	            	}
            	}
            }
            
			function q_funcPost(t_func, result) {
				switch(t_func) {
					case 'qtxt.query.changequatgweight':
						break;
					case 'qtxt.query.packing':
						//要刷新畫面才會顯示bbs
						var s2=new Array('vcc_vu_s',"where=^^noa<='"+$('#txtNoa').val()+"' ^^ ");
						q_boxClose2(s2);
						break;
					case 'qtxt.query.vcct':
						//要刷新畫面才會顯示bbs
						var s2=new Array('vcc_vu_s',"where=^^noa<='"+$('#txtNoa').val()+"' ^^ ");
						q_boxClose2(s2);
						break;
				}
			}

			function q_boxClose(s2) {
				var ret;
				switch (b_pop) {
					case 'quat1_b':
						if (q_cur > 0 && q_cur < 4) {
							b_ret = getb_ret();
							if (!b_ret || b_ret.length == 0 || b_ret[0]==undefined)
								return;
							$('#textQno1').val(b_ret[0].noa);
							$('#txtSalesno').val(b_ret[0].salesno);
							$('#txtSales').val(b_ret[0].sales);
							$('#txtAddr2').val(b_ret[0].addr2);
							if(b_ret[0].atax=="true"){
								$('#chkAtax').prop('checked',true);
							}else{
								$('#chkAtax').prop('checked',false);	
							}
							refreshBbm();
							sum();
						}
						break;
					case 'quat2_b':
						if (q_cur > 0 && q_cur < 4) {
							b_ret = getb_ret();
							if (!b_ret || b_ret.length == 0 || b_ret[0]==undefined)
								return;
							$('#textQno2').val(b_ret[0].noa);
							if(b_ret[0].atax=="true"){
								$('#chkAtax').prop('checked',true);
							}else{
								$('#chkAtax').prop('checked',false);	
							}
							refreshBbm();
							sum();
						}
						break;
					case 'ordes':
						if (q_cur > 0 && q_cur < 4) {
							b_ret = getb_ret();
							if (!b_ret || b_ret.length == 0)
								return;
							
							ret = q_gridAddRow(bbsHtm, 'tbbs', 'txtProduct,txtSpec,txtSize,txtLengthb,txtClass,txtUnit,txtPrice,txtMount,txtWeight,txtOrdeno,txtNo2'
							, b_ret.length, b_ret, 'product,spec,size,lengthb,class,unit,price,mount,weight,noa,no2', 'txtProduct,txtSpec');
							//寫入訂單號碼
							var t_oredeno = '',t_quatno='';
							for (var i = 0; i < b_ret.length; i++) {
								if (t_oredeno.indexOf(b_ret[i].noa) == -1)
									t_oredeno = t_oredeno + (t_oredeno.length > 0 ? (',' + b_ret[i].noa) : b_ret[i].noa);
								if (t_quatno.indexOf(b_ret[i].quatno) == -1)
									t_quatno = t_quatno + (t_quatno.length > 0 ? (',' + b_ret[i].quatno) : b_ret[i].quatno);
							}
							//取得訂單備註 + 指定地址
							if (t_oredeno.length > 0) {
								var t_where = "where=^^ charindex(noa,'" + t_oredeno + "')>0 ^^";
								q_gt('orde', t_where, 0, 0, 0, "", r_accy);
							}

							$('#txtOrdeno').val(t_oredeno);
							$('#txtZipcode').val(t_quatno);
							sum();
						}
						break;
					/*case 'pack':						
						if(!emp($('#txtNoa').val()))
							q_func('qtxt.query.packing', 'vcc.txt,changepacking_vu,' + encodeURI(r_accy) + ';' + encodeURI($('#txtNoa').val())+ ';' + encodeURI(r_name));
						break;*/
					case q_name + '_s':
						q_boxClose2(s2);
						break;
				}
				b_pop = '';
			}

			var t_msg = '';
			var focus_addr = '';
			var z_cno = r_cno, z_acomp = r_comp, z_nick = r_comp.substr(0, 2);
			var carnoList = [];
			var thisCarSpecno = '';
			var q1_weight=0,q2_weight=0;
			function q_gtPost(t_name) {
				var as;
				switch (t_name) {
					case 'ucc':
						var as = _q_appendData("ucc", "", true);
						var t_ucc='@';
						for ( i = 0; i < as.length; i++) {
							t_ucc+=","+as[i].product;
						}
						q_cmbParse("combProduct", t_ucc,'s');
						q_cmbParse("combProduct", t_ucc,'t');
						break;
					case 'bbsspec':
						var as = _q_appendData("spec", "", true);
						var t_spec='@';
						for ( i = 0; i < as.length; i++) {
							t_spec+=","+as[i].noa;
						}
						q_cmbParse("combSpec", t_spec,'s');
						q_cmbParse("combSpec", t_spec,'t');
						break;
					case 'bbscolor':
						var as = _q_appendData("color", "", true);
						var t_color='@';
						for ( i = 0; i < as.length; i++) {
							t_color+=","+as[i].color;
						}
						q_cmbParse("combUcolor", t_color,'s');
						q_cmbParse("combUcolor", t_color,'t');
						break;
					case 'bbsclass':
						var as = _q_appendData("class", "", true);
						var t_class='@';
						for ( i = 0; i < as.length; i++) {
							t_class+=","+as[i].noa;
						}
						q_cmbParse("combClass", t_class,'s');
						q_cmbParse("combClass", t_class,'t');
						break;
					case 'quat_btnOk':
						var as = _q_appendData("view_quat", "", true);
						var qno1_exists=(emp($('#textQno1').val())?true:false);
						var qno2_exists=(emp($('#textQno2').val())?true:false);
						var qcust1='',qcust2='';
						for ( i = 0; i < as.length; i++) {
							if(as[i].noa==$('#textQno1').val()){
								qno1_exists=true;
								q1_weight=dec(as[i].weight);
								qcust1=trim(as[i].custno);
							}
							if(as[i].noa==$('#textQno2').val()){
								qno2_exists=true;
								q2_weight=dec(as[i].weight);
								qcust2=trim(as[i].custno);
							}
						}
						
						if (!qno1_exists || !qno2_exists) {
							var t_qno='';
							if(!qno1_exists)
								t_qno=$('#textQno1').val();
							if(!qno2_exists)
								t_qno=t_qno+(t_qno.length>0?',':'')+$('#textQno2').val();
							alert(t_qno+'合約號碼不存在!!');
						}else if(qcust1 && qcust1!=trim($('#txtCustno').val()) || qcust2 && qcust2!=trim($('#txtCustno').val())){
							alert('合約客戶與出貨客戶不同!!');
						}else{
							var t_where = "where=^^ (1=0 "+(!emp($('#textQno1').val())?" or charindex('"+$('#textQno1').val()+"',apvmemo)>0 ":'')+(!emp($('#textQno2').val())?" or charindex('"+$('#textQno2').val()+"',apvmemo)>0 ":'')+ ")  ^^"; //and noa!='"+$('#txtNoa').val()+"'
							q_gt('view_vcc', t_where, 0, 0, 0, "quat_view_vcc", r_accy);
						}
						break;
					case 'quat_view_vcc':
						var as = _q_appendData("view_vcc", "", true);
						for ( i = 0; i < as.length; i++) {
							if(as[i].noa!=$('#txtNoa').val()){
								var t_quat=as[i].apvmemo.split('##');
								if(t_quat[0]!=undefined){
									var r_quat=t_quat[0].split('@');
									if(r_quat[0]==$('#textQno1').val()){
										if(as[i].typea=='2'){
											q1_weight=q_add(q1_weight,dec(r_quat[1]));
										}else{
											q1_weight=q_sub(q1_weight,dec(r_quat[1]));
										}
									}
									if(r_quat[0]==$('#textQno2').val()){
										if(as[i].typea=='2'){
											q2_weight=q_add(q2_weight,dec(r_quat[1]));
										}else{
											q2_weight=q_sub(q2_weight,dec(r_quat[1]));
										}
									}
								}
								if(t_quat[1]!=undefined){
									var r_quat=t_quat[1].split('@');
									if(r_quat[0]==$('#textQno1').val()){
										if(as[i].typea=='2'){
											q1_weight=q_add(q1_weight,dec(r_quat[1]));
										}else{
											q1_weight=q_sub(q1_weight,dec(r_quat[1]));
										}
									}
									if(r_quat[0]==$('#textQno2').val()){
										if(as[i].typea=='2'){
											q2_weight=q_add(q2_weight,dec(r_quat[1]));
										}else{
											q2_weight=q_sub(q2_weight,dec(r_quat[1]));
										}
									}
								}
							}else{
								var t_quat=as[i].apvmemo.split('##');
								if(t_quat[0]!=undefined){
									var r_quat=t_quat[0].split('@');
									t_cont1=r_quat[0];
								}
								if(t_quat[1]!=undefined){
									var r_quat=t_quat[1].split('@');
									t_cont2=r_quat[0];
								}
							}
						}
						if((q1_weight>=dec($('#textQweight1').val()) && q2_weight>=dec($('#textQweight2').val())) ||  $('#cmbTypea').val()=='2'){
							check_quat=true;
							btnOk();
						}else{
							var t_err='';
							if(q1_weight<dec($('#textQweight1').val()))
								t_err+='合約號碼【'+$('#textQno1').val()+'】合約剩餘重量'+FormatNumber(q1_weight)+'小於出貨重量'+FormatNumber($('#textQweight1').val());
							if(q2_weight<dec($('#textQweight2').val()))
								t_err+=(t_err.length>0?'\n':'')+'合約號碼【'+$('#textQno2').val()+'】合約剩餘重量'+FormatNumber(q2_weight)+'小於出貨重量'+FormatNumber($('#textQweight2').val());
							alert(t_err);
						}
						q1_weight=0,q2_weight=0;
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
					case 'custms':
						var ass = _q_appendData("custms", "", true);
						if(ass[0] != undefined){
							var t_item = " @ ";
							for ( i = 0; i < ass.length; i++) {
								t_item = t_item + (t_item.length > 0 ? ',' : '') + ass[i].account + '@' + ass[i].account;
							}
							$('#combAddr').text('');
							q_cmbParse("combAddr", t_item);
						}else{
							$('#combAddr').text('');
						}
						break;
					case 'orde':
						var as = _q_appendData("orde", "", true);
						var t_memo = $('#txtMemo').val();
						var t_post = '';
						var t_addr = '';
						var t_post2 = '';
						var t_addr2 = '';
						for ( i = 0; i < as.length; i++) {
							t_memo = t_memo + (t_memo.length > 0 ? '\n' : '') + as[i].noa + ':' + as[i].memo;
							t_post = t_post+(t_post.length>0?';':'')+as[i].post;
							t_addr = t_addr+(t_addr.length>0?';':'')+as[i].addr;
							t_post2 = t_post2+(t_post2.length>0?';':'')+as[i].post2;
							t_addr2 = t_addr2+(t_addr2.length>0?';':'')+as[i].addr2;
						}
						$('#txtMemo').val(t_memo);
						$('#txtPost').val(t_post);
						$('#txtAddr').val(t_addr);
						$('#txtPost2').val(t_post2);
						$('#txtAddr2').val(t_addr2);
						if (as[0] != undefined){
							$('#txtSalesno').val(as[0].salesno);
							$('#txtSales').val(as[0].sales);
							//$('#cmbTaxtype').val(as[0].taxtype);
						}
						sum();
						break;
					case 'cust':
						var as = _q_appendData("cust", "", true);
						if (as[0] != undefined && focus_addr != '') {
							$('#' + focus_addr).val(as[0].addr_fact);
							focus_addr = '';
						}
						break;
					case 'btnDele':
						var as = _q_appendData("umms", "", true);
						if (as[0] != undefined) {
							var z_msg = "", t_paysale = 0;
							for (var i = 0; i < as.length; i++) {
								t_paysale = parseFloat(as[i].paysale.length == 0 ? "0" : as[i].paysale);
								if (t_paysale != 0)
									z_msg += String.fromCharCode(13) + '收款單號【' + as[i].noa + '】 ' + FormatNumber(t_paysale);
							}
							if (z_msg.length > 0) {
								alert('已沖帳:' + z_msg);
								Unlock(1);
								return;
							}
						}
						_btnDele();
						Unlock(1);
						break;
					case 'btnModi':
						var as = _q_appendData("umms", "", true);
						if (as[0] != undefined) {
							var z_msg = "", t_paysale = 0;
							for (var i = 0; i < as.length; i++) {
								t_paysale = parseFloat(as[i].paysale.length == 0 ? "0" : as[i].paysale);
								if (t_paysale != 0)
									z_msg += String.fromCharCode(13) + '收款單號【' + as[i].noa + '】 ' + FormatNumber(t_paysale);
							}
							if (z_msg.length > 0) {
								alert('已沖帳:' + z_msg);
								Unlock(1);
								return;
							}
						}
						_btnModi();
						Unlock(1);
						$('#txtDatea').focus();
						
						//取得車號下拉式選單
						var thisVal = $('#txtCardealno').val();
						var t_where = "where=^^ noa=N'" + thisVal + "' ^^";
						q_gt('cardeal', t_where, 0, 0, 0, "getCardealCarno");
						break;
					case q_name:
						if (q_cur == 4)
							q_Seek_gtPost();
						break;
					case 'sss':
						as = _q_appendData('sss', '', true);
						break;
					case 'startdate':
						var as = _q_appendData('cust', '', true);
						var t_startdate='';
						if (as[0] != undefined) {
							t_startdate=as[0].startdate;
						}
						if(t_startdate.length==0 || ('00'+t_startdate).slice(-2)=='00' || $('#txtDatea').val().substr(7, 2)<('00'+t_startdate).slice(-2)){
							$('#txtMon').val($('#txtDatea').val().substr(0, r_lenm));
						}else{
							var t_date=$('#txtDatea').val();
							var nextdate='';
							if(r_len==4)
								nextdate=new Date(dec(t_date.substr(0,4)),dec(t_date.substr(5,2))-1,1);
							else
								nextdate=new Date(dec(t_date.substr(0,3))+1911,dec(t_date.substr(4,2))-1,1);
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
					case 'getordes':
						var as = _q_appendData('view_ordes', '', true);
						if (as[0] != undefined) {
							var t_nocust=true;
							if(!emp($('#txtCustno').val())){
								for (var i = 0; i < as.length; i++) {
									if(as[i].custno!=$('#txtCustno').val())
										t_nocust=false;
								}
							}
							if(!t_nocust){
								alert('領料批號含其他客戶的訂單批號!!');
							}else{
								for (var i = 0; i < q_bbsCount; i++) {
			                		$('#btnMinus_'+i).click();
			                	}
								q_gridAddRow(bbsHtm, 'tbbs', 'txtProduct,txtUcolor,txtSpec,txtSize,txtLengthb,txtClass,txtPrice,txtMount,txtWeight,txtOrdeno,txtNo2'
								, as.length, as, 'product,ucolor,spec,size,lengthb,class,price,mount,weight,noa,no2', 'txtProduct,txtSpec');
								
								for (var i = 0; i < q_bbsCount; i++) {
									var t_ordeno='',t_no2='',t_mount=0,t_weight=0;
									if(!emp($('#txtOrdeno_'+i).val())){
										t_ordeno=$('#txtOrdeno_'+i).val();
										t_no2=$('#txtNo2_'+i).val();
										for (var j = 0; j < q_bbtCount; j++) {
											if($('#txtOrdeno__'+j).val()==t_ordeno && $('#txtNo2__'+j).val()==t_no2){
												t_mount=q_add(t_mount,dec($('#txtMount__'+j).val()));
												t_weight=q_add(t_weight,dec($('#txtWeight__'+j).val()));
											}
										}
										$('#txtMount_'+i).val(t_mount);
										$('#txtWeight_'+i).val(t_weight);
									}
								}
							}
							sum();
						}/*else{
							alert('無訂單資料!!');
						}*/
						break;
					case 'checkVccno_btnOk':
						var as = _q_appendData("view_vcc", "", true);
                        if (as[0] != undefined) {
                            alert('出貨單號已存在!!!');
                        } else {
                            wrServer($('#txtNoa').val());
                        }
						break;
					case 'qno1_chage':
						var as = _q_appendData("view_quat", "", true);
						if (as[0] != undefined) {
							if((as[0].enda)=="true" && $('#cmbTypea').val()!='2'){
								alert($('#textQno1').val()+'合約已結案!');
							}else if(dec(as[0].eweight)<=0  && $('#cmbTypea').val()!='2'){
								alert($('#textQno1').val()+'合約已出貨完畢!');
							}else if(!emp($('#txtCustno').val()) && $('#txtCustno').val()!=as[0].custno){
								alert('合約客戶與出貨客戶不同!!');
							}else{
								if(as[0].atax=="true"){
									$('#chkAtax').prop('checked',true);
									$('#txtSalesno').val(as[0].salesno);
									$('#txtSales').val(as[0].sales);
									$('#txtAddr2').val(as[0].addr2);
								}else{
									$('#chkAtax').prop('checked',false);
									$('#txtSalesno').val(as[0].salesno);
									$('#txtSales').val(as[0].sales);
									$('#txtAddr2').val(as[0].addr2);
								}
								refreshBbm();
								sum();
							}
						}else{
							alert($('#textQno1').val()+'合約不存在!!!');
						}
						break;
					case 'qno2_chage':
						var as = _q_appendData("view_quat", "", true);
						if (as[0] != undefined) {
							if((as[0].enda)=="true" && $('#cmbTypea').val()!='2'){
								alert($('#textQno2').val()+'合約已結案!');
							}else if(dec(as[0].eweight)<=0 && $('#cmbTypea').val()!='2'){
								alert($('#textQno2').val()+'合約已出貨完畢!');
							}else if(!emp($('#txtCustno').val()) && $('#txtCustno').val()!=as[0].custno){
								alert('合約客戶與出貨客戶不同!!');
							}else{
							if(as[0].atax=="true"){
								$('#chkAtax').prop('checked',true);
								}else{
									$('#chkAtax').prop('checked',false);	
								}
								refreshBbm();
								sum();
							}
						}else{
							alert($('#textQno2').val()+'合約不存在!!!');
						}
						break;
				}
				if(t_name.substring(0,10)=='getunovcct'){
					var n=t_name.split('_')[1];
					var as = _q_appendData('view_vcct', '', true);
					if (as[0] != undefined) {
						alert('該批號已出貨!!');
						$('#btnMinut__'+n).click();
					}else{
						//105/08/12 加上判斷cub 被領料
						//var t_where = "where=^^ uno='" + $('#txtUno__' + n).val() + "' and (weight<0 or mount<0) ^^";
						//q_gt('view_cubs', t_where, 0, 0, 0, "getunocubs_"+n);
						//106/05/23 多判斷get是否出貨
						var t_where = "where=^^ uno='" + $('#txtUno__' + n).val() + "' and noa!='"+$('#txtNoa').val()+"' ^^";
						q_gt('view_gett', t_where, 0, 0, 0, "getunogett_"+b_seq);
					}
				}else if(t_name.substring(0,10)=='getunogett'){
					var n=t_name.split('_')[1];
					var as = _q_appendData('view_gett', '', true);
					if (as[0] != undefined) {
						alert('該批號已出貨!!');
						$('#btnMinut__'+n).click();
					}else{
						//105/08/12 加上判斷cub 被領料
						var t_where = "where=^^ uno='" + $('#txtUno__' + n).val() + "' and (weight<0 or mount<0) ^^";
						q_gt('view_cubs', t_where, 0, 0, 0, "getunocubs_"+n);
					}
				}else if (t_name.substring(0,10)=='getunocubs'){
					var n=t_name.split('_')[1];
					var as = _q_appendData('view_cubs', '', true);
					if (as[0] != undefined) {
						alert('該批號已被領料!!');
						$('#btnMinut__'+n).click();
					}else{
						q_gt('view_orde', "where=^^ exists( select * from view_cubs where ordeno=view_orde.noa  and uno='"+$('#txtUno__'+n).val()+"' ) ^^ ", 0, 0, 0, "getordecust_"+n);
					}
				}else if (t_name.substring(0,11)=='getordecust'){
					var n=t_name.split('_')[1];
					var as = _q_appendData('view_orde', '', true);
					if (as[0] != undefined) {
						if(emp($('#txtCustno').val())){
							$('#txtCustno').val(as[0].custno);
							$('#txtComp').val(as[0].comp);
							$('#txtNick').val(as[0].nick);
							$('#txtTel').val(as[0].tel);
							$('#txtFax').val(as[0].fax);
							$('#txtPaytype').val(as[0].paytype);
							$('#cmbTrantype').val(as[0].trantype);
							$('#txtPost').val(as[0].post);
							$('#txtAddr').val(as[0].addr);
							$('#txtAddr2').val(as[0].addr2);
							
							q_gt('view_cubs', "where=^^uno='"+$('#txtUno__'+n).val()+"' and (weight>=0 and mount>=0) ^^ ", 0, 0, 0, "getcubsuno_"+n);
						}else{
							if($('#txtCustno').val()!=as[0].custno){
								alert('該批號訂單客戶與出貨客戶不同!!');
								$('#btnMinut__'+b_seq).click();
							}else{
								q_gt('view_cubs', "where=^^uno='"+$('#txtUno__'+n).val()+"'  and (weight>=0 and mount>=0) ^^ ", 0, 0, 0, "getcubsuno_"+n);
							}
						}
					}else{
						q_gt('view_cubs', "where=^^uno='"+$('#txtUno__'+b_seq).val()+"'  and (weight>=0 and mount>=0) ^^ ", 0, 0, 0, "getcubsuno_"+n);
					}
					/*else{
						alert('該訂單批號不存在!!');
						$('#btnMinut__'+b_seq).click();
					}*/
				}else if (t_name.substring(0,10)=='getcubsuno'){
					var n=t_name.split('_')[1];
					var as = _q_appendData('view_cubs', '', true);
					if (as[0] != undefined) {
						$('#btnMinut__'+n).click();
						q_gridAddRow(bbtHtm, 'tbbt', 'txtProduct,txtUcolor,txtSpec,txtSize,txtLengthb,txtClass,txtMount,txtWeight,txtUno,txtMemo,txtOrdeno,txtNo2,txtItemno,txtItem'
							, as.length, as, 'product,ucolor,spec,size,lengthb,class,mount,weight,uno,memo,ordeno,no2,noa,noq', 'txtUno');
						
						if(dec(n)+as.length>=q_bbtCount){
							$('#btnPlut').click();
						}
						$('#txtUno__'+q_add(dec(n),as.length)).focus().select();
						//檢查批號是否重複 已 cubsnoa和cubsnoq為主
						var t_repeat=false;
						for (var i = 0; i < q_bbtCount; i++) {
							var t_cubsnoa=$('#txtItemno__'+i).val();
							var t_cubsnoq=$('#txtItem__'+i).val();
							if(t_cubsnoa.length>0){
								for (var j = i+1; j < q_bbtCount; j++) {
									if(t_cubsnoa==$('#txtItemno__'+j).val() &&t_cubsnoq==$('#txtItem__'+j).val()){
										t_repeat=true;
										$('#btnMinut__'+j).click();
									}
								}
							}
						}
						if(t_repeat){
							alert('該批號重複!!');
							$('#txtUno__'+(dec(n))).focus();
						}
					}else{
						alert('無此批號!!');
						$('#btnMinut__'+n).click();
					}
					bbtsum();
				}
			}
			
			var check_startdate=false;
			var check_quat=false;
			function btnOk() {
				var t_err = q_chkEmpField([['txtNoa', q_getMsg('lblNoa')],['txtDatea', q_getMsg('lblDatea')], ['txtCustno', q_getMsg('lblCust')], ['txtCno', q_getMsg('lblAcomp')]]);
				if (t_err.length > 0) {
					alert(t_err);
					return;
				}
				
				if((!emp($('#textQno1').val()) || !emp($('#textQno2').val())) && dec($('#txtWeight').val())!=q_add(dec($('#textQweight1').val()),dec($('#textQweight2').val()))){
					alert('合約重量'+FormatNumber(q_add(dec($('#textQweight1').val()),dec($('#textQweight2').val())))+'不等於出貨淨重'+FormatNumber(dec($('#txtWeight').val()))+'!!');
					return;
				}
				
				if((!emp($('#textQno1').val()) && !emp($('#textQno2').val())) && $('#textQno1').val()==$('#textQno2').val() ){
					alert('合約1號碼與合約2號碼相同!!');
					return;
				}
				
				var nostore=false;
				for (var i = 0; i < q_bbsCount; i++) {
					if((dec($('#txtMount_'+i).val())>0 || dec($('#txtWeight_'+i).val())>0) && emp($('#txtStoreno_'+i).val()))
						nostore=true;
				}
				
				if(nostore){
					alert('出貨倉庫未填入!!');
					return;
				}
				
				//判斷起算日,寫入帳款月份
				//104/09/30 如果備註沒有*字就重算帳款月份
				//if(!check_startdate && emp($('#txtMon').val())){
				if(!check_startdate && $('#txtMemo').val().substr(0,1)!='*'){	
					var t_where = "where=^^ noa='"+$('#txtCustno').val()+"' ^^";
					q_gt('cust', t_where, 0, 0, 0, "startdate", r_accy);
					return;
				}
				/*if (emp($('#txtMon').val()))
					$('#txtMon').val($('#txtDatea').val().substr(0, r_lenm));*/
				
				//檢查合約是否存在或已結案
				if(!check_quat && (!emp($('#textQno1').val()) || !emp($('#textQno2').val()))){
					var t_where = "where=^^ 1=0 "+(!emp($('#textQno1').val())?" or noa='"+$('#textQno1').val()+"' ":'')+(!emp($('#textQno2').val())?" or noa='"+$('#textQno2').val()+"' ":'')+ " ^^";
					q_gt('view_quat', t_where, 0, 0, 0, "quat_btnOk", r_accy);
					return;
				}
				
				check_quat=false;
				check_startdate=false;
				
				$('#txtApvmemo').val($('#textQno1').val()+'@'+dec($('#textQweight1').val())+'##'+$('#textQno2').val()+'@'+dec($('#textQweight2').val()));
					
				if (q_cur == 1){
					$('#txtWorker').val(r_name);
					if($('#txtPaydate').val().length==0 || $('#txtPaydate').val()=='AUTO'){
						var today = new Date();
						$('#txtPaydate').val(padL(today.getHours(), '0', 2)+':'+padL(today.getMinutes(),'0',2));
					}
				}else
					$('#txtWorker2').val(r_name);
					
				sum();

				var s1 = $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val();
				if (s1.length == 0 || s1 == "AUTO")
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_vcc') + $('#txtDatea').val(), '/', ''));
				else{
					if (q_cur == 1){
						t_where = "where=^^ noa='" + $('#txtNoa').val() + "'^^";
                    	q_gt('view_vcc', t_where, 0, 0, 0, "checkVccno_btnOk", r_accy);
					}else{					
						wrServer(s1);
					}
				}
			}

			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)// 1-3
					return;
				q_box('vcc_vu_s.aspx', q_name + '_s', "500px", "630px", q_getMsg("popSeek"));
			}

			function combPay_chg() {
				var cmb = document.getElementById("combPay");
				if (!q_cur)
					cmb.value = '';
				else
					$('#txtPaytype').val(cmb.value);
				cmb.value = '';
			}
			
			function coin_chg() {
				var t_where = "where=^^ ('" + $('#txtDatea').val() + "' between bdate and edate) and coin='"+$('#cmbCoin').find("option:selected").text()+"' ^^";
				q_gt('flors', t_where, 0, 0, 0, "");
			}

			function combAddr_chg() {
				if (q_cur == 1 || q_cur == 2) {
					$('#txtAddr2').val($('#combAddr').find("option:selected").val());
				}
			}
			
			var mouse_point;
			function bbsAssign() {
				for (var i = 0; i < q_bbsCount; i++) {
					if (!$('#btnMinus_' + i).hasClass('isAssign')) {
						/*$('#combOrdelist_'+i).change(function(){
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length-1];
							var thisVal = $.trim($(this).val());
							var ValArray = thisVal.split('-');
							if(ValArray[0] && ValArray[1]){
								$('#txtOrdeno_' + n).val(ValArray[0]);
								$('#txtNo2_' + n).val(ValArray[1]);
							}
							$(this).val('');
						});*/
						
						$('#txtPrice_' + i).change(function() {
							_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if (q_cur == 1 || q_cur == 2){
								var t_weight=dec($('#txtWeight_' + b_seq).val());
								var t_mount=dec($('#txtMount_' + b_seq).val());
								var t_price=dec($('#txtPrice_' + b_seq).val());
								
								if($('#txtProduct_'+b_seq).val().indexOf('續接器')>-1 || $('#txtProduct_'+b_seq).val()=='水泥方塊' || $('#txtProduct_'+b_seq).val()=='組裝工資')
									$('#txtTotal_' + b_seq).val(round(q_mul(t_price, t_mount), 0));
								else if($('#txtProduct_'+b_seq).val()=='運費'  || $('#txtProduct_'+b_seq).val()=='加工費用'){
									var sot_weight=0;
	                                for (var i = 0; i < q_bbsCount; i++) {
	                                    sot_weight=q_add(sot_weight,dec($('#txtWeight_'+i).val()));
	                                }
	                                $('#txtTotal_'+b_seq).val(round(q_mul(t_price,sot_weight),0));
								}else{
									$('#txtTotal_'+b_seq).val(round(q_mul(t_price, t_weight), 0));
								}
								sum();
							}
						});
						$('#txtTotal_' + i).change(function() {
							if (q_cur == 1 || q_cur == 2)
								sum();
						});
						
						$('#txtMount_' + i).change(function() {
							_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if (q_cur == 1 || q_cur == 2){
								var t_weight=dec($('#txtWeight_' + b_seq).val());
								var t_mount=dec($('#txtMount_' + b_seq).val());
								var t_price=dec($('#txtPrice_' + b_seq).val());
								
								if($('#txtProduct_'+b_seq).val().indexOf('續接器')>-1 || $('#txtProduct_'+b_seq).val()=='水泥方塊' || $('#txtProduct_'+b_seq).val()=='組裝工資')
									$('#txtTotal_' + b_seq).val(round(q_mul(t_price, t_mount), 0));
								else if($('#txtProduct_'+b_seq).val()=='運費'  || $('#txtProduct_'+b_seq).val()=='加工費用'){
									var sot_weight=0;
	                                for (var i = 0; i < q_bbsCount; i++) {
	                                    sot_weight=q_add(sot_weight,dec($('#txtWeight_'+i).val()));
	                                }
	                                $('#txtTotal_'+b_seq).val(round(q_mul(t_price,sot_weight),0));
								}else{
									$('#txtTotal_'+b_seq).val(round(q_mul(t_price, t_weight), 0));
								}
								sum();
							}
						});
						
						$('#txtWeight_' + i).change(function() {
							_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if (q_cur == 1 || q_cur == 2){
								var t_weight=dec($('#txtWeight_' + b_seq).val());
								var t_mount=dec($('#txtMount_' + b_seq).val());
								var t_price=dec($('#txtPrice_' + b_seq).val());
								
								if($('#txtProduct_'+b_seq).val().indexOf('續接器')>-1 || $('#txtProduct_'+b_seq).val()=='水泥方塊' || $('#txtProduct_'+b_seq).val()=='組裝工資')
									$('#txtTotal_' + b_seq).val(round(q_mul(t_price, t_mount), 0));
								else if($('#txtProduct_'+b_seq).val()=='運費'  || $('#txtProduct_'+b_seq).val()=='加工費用'){
									var sot_weight=0;
	                                for (var i = 0; i < q_bbsCount; i++) {
	                                    sot_weight=q_add(sot_weight,dec($('#txtWeight_'+i).val()));
	                                }
	                                $('#txtTotal_'+b_seq).val(round(q_mul(t_price,sot_weight),0));
								}else{
									$('#txtTotal_'+b_seq).val(round(q_mul(t_price, t_weight), 0));
								}
								sum();
							}
							sum();
							bbssum();
						});
						
						$('#btnRecord_' + i).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							//t_where = "cust='" + $('#txtCustno').val() + "' and noq='" + $('#txtProductno_' + b_seq).val() + "'";
							t_where = "custno='" + $('#txtCustno').val() + "' and comp='" + $('#txtComp').val() + "' and productno='" + $('#txtProductno_' + b_seq).val() + "' and product='" + $('#txtProduct_' + b_seq).val() + "'";
							q_box("z_vccrecord.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'vccrecord', "95%", "95%", q_getMsg('lblRecord_s'));
						});
						
						$('#combUcolor_' + i).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtUcolor_'+b_seq).val($('#combUcolor_'+b_seq).find("option:selected").text());
						});
						
						$('#txtSize_' + i).change(function() {
							 if ($(this).val().substr(0, 1) != '#')
                        		$(this).val('#' + $(this).val());
						});
						
						$('#combSpec_' + i).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtSpec_'+b_seq).val($('#combSpec_'+b_seq).find("option:selected").text());
						});
						
						$('#combClass_' + i).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtClass_'+b_seq).val($('#combClass_'+b_seq).find("option:selected").text());
						});
						
						$('#combProduct_' + i).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2){
								$('#txtProduct_'+b_seq).val($('#combProduct_'+b_seq).find("option:selected").text());
								if($('#txtProduct_'+b_seq).val()=='運費'){
									var sot_weight=0;
					                for (var i = 0; i < q_bbsCount; i++) {
						                sot_weight=q_add(sot_weight,dec($('#txtWeight_'+i).val()));
									}
									$('#txtTotal_'+b_seq).val(round(q_mul(dec($('#txtPrice_'+b_seq).val()),sot_weight),0));
								}
								totalreadonly();
							}
						});
						
						$('#txtProduct_' + i).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							totalreadonly();
							if($('#txtProduct_'+b_seq).val()=='運費'){
								var sot_weight=0;
								for (var i = 0; i < q_bbsCount; i++) {
									sot_weight=q_add(sot_weight,dec($('#txtWeight_'+i).val()));
								}
								$('#txtTotal_'+b_seq).val(round(q_mul(dec($('#txtPrice_'+b_seq).val()),sot_weight),0));
							}
						});
						
						$('#btnMinus_' + i).click(function() {
							setTimeout(bbssum,10);
							sum();
						});
					}
				}
				_bbsAssign();
				HiddenTreat();
				refreshBbm();
				refreshBbs();
				
				$('#lblNoq_s').text('項序');
				$('#lblProductno_s').text('品號');
				$('#lblProduct_s').text('品名');
				$('#lblUcolor_s').text('類別');
				$('#lblStyle_s').text('型');
				$('#lblSpec_s').text('材質');
				$('#lblSize_s').text('號數');
				$('#lblLengthb_s').text('米數');
				$('#lblClass_s').text('廠牌');
				$('#lblUnit_s').text('單位');
				$('#lblMount_s').text('數量(件)');
				$('#lblWeight_s').text('重量(KG)');
				$('#lblPrice_s').text('單價');
				$('#lblTotal_s').text('小計');
				$('#lblMemo_s').text('備註');
				$('#lblStore_s').text('出貨倉庫');
				bbssum();
				
				//1050126
				$('#btnStoreCopy').click(function() {
					if(q_cur==1 || q_cur==2){
                		if(!emp($('#txtStoreno_0').val())){
	                		for (var i = 1; i < q_bbsCount; i++) {
	                			if(emp($('#txtStoreno_'+i).val())){
	                				$('#txtStoreno_'+i).val($('#txtStoreno_0').val());
	                				$('#txtStore_'+i).val($('#txtStore_0').val());
	                			}
	                		}
                		}
                	}
				});
			}
			
			function bbssum() {
            	var sot_mount=0,sot_weight=0;
                for (var i = 0; i < q_bbsCount; i++) {
	                sot_mount=q_add(sot_mount,dec($('#txtMount_'+i).val()));
	                sot_weight=q_add(sot_weight,dec($('#txtWeight_'+i).val()));
	                
				}
				if(sot_mount!=0)
					$('#lblSot_mount').text(FormatNumber(sot_mount));
				else
					$('#lblSot_mount').text('');
				if(sot_weight!=0){
					$('#lblSot_weight').text(FormatNumber(sot_weight));
					if(q_cur==1 || q_cur==2)
						$('#textQweight1').val(FormatNumber(sot_weight));
				}else
					$('#lblSot_weight').text('');
            }
			
			function bbtAssign() {
                for (var i = 0; i < q_bbtCount; i++) {
                    $('#lblNo__' + i).text(i + 1);
                    if (!$('#btnMinut__' + i).hasClass('isAssign')) {
                    	$('#btnMinut__' + i).click(function() {
							setTimeout(bbtsum,10);
						});
						
						$('#txtMount__'+i).focusout(function() {
							if(q_cur==1 || q_cur==2)
								bbtsum();
						});
						
						$('#txtWeight__'+i).focusout(function() {
							if(q_cur==1 || q_cur==2)
								bbtsum();
						});
                    	
                    	$('#combUcolor__' + i).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtUcolor__'+b_seq).val($('#combUcolor__'+b_seq).find("option:selected").text());
						});
						$('#txtSize__' + i).change(function() {
							 if ($(this).val().substr(0, 1) != '#')
                        		$(this).val('#' + $(this).val());
						});
						$('#combSpec__' + i).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtSpec__'+b_seq).val($('#combSpec__'+b_seq).find("option:selected").text());
						});
						
						$('#combClass__' + i).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtClass__'+b_seq).val($('#combClass__'+b_seq).find("option:selected").text());
						});
						
						$('#combProduct__' + i).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtProduct__'+b_seq).val($('#combProduct__'+b_seq).find("option:selected").text());
						});
						
						/*$('#txtProduct__'+i).focusin(function(e) {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							
							if(q_cur==1 || q_cur==2){
								var t_b_seq=dec(b_seq)+1;
								if(t_b_seq>=q_bbtCount){
									$('#btnPlut').click();
								}
								
								$('#txtUno__'+t_b_seq).focus();
							}
						});*/
                    }
                }
                $('#btnVccttoOrde').click(function() {
                	if(q_cur==1 || q_cur==2){
	                	/*var t_ordeno="";
	                	for (var i = 0; i < q_bbtCount; i++) {
	                		if(!emp($('#txtUno__'+i).val())){
	                			t_ordeno=t_ordeno+$('#txtUno__'+i).val()+'##';
	                		}
	                	}
	                	if(t_ordeno.length>0){
	                		//q_gt('view_ordes', "where=^^charindex(isnull(noa,'')+isnull(no2,''),'"+t_ordeno+"')>0 ^^ ", 0, 0, 0, "getordes");
	                		//104/10/27 不處理直接加總
	                		//q_gt('view_ordes', "where=^^ exists( select * from view_cubs where ordeno=view_ordes.noa and no2=view_ordes.no2 and charindex(uno,'"+t_ordeno+"')>0 ) ^^ ", 0, 0, 0, "getordes");
	                	}*/
	                	
	                	//104/1031 恢復依號數、材質、類別小計
	                	for (var i = 0; i < q_bbsCount; i++) {
	                		//if(!emp($('#txtOrdeno_'+i).val()))
			            		$('#btnMinus_'+i).click();
						}
						
						var as=[],tot_uno='';
						for (var i = 0; i < q_bbtCount; i++) {
							if(!emp($('#txtUno__'+i).val())){
								var is_exists=false;
								for (var j = 0; j < as.length; j++) {
									if(as[j].product==$('#txtProduct__'+i).val() 
									&& as[j].ucolor==$('#txtUcolor__'+i).val()
									&& as[j].spec==$('#txtSpec__'+i).val()
									&& as[j].size==$('#txtSize__'+i).val()
									//&& as[j].noa==$('#txtOrdeno__'+i).val()
									//&& as[j].no2==$('#txtNo2__'+i).val()
									){
										is_exists=true;
										if(!emp($('#txtUno__'+i).val())&& tot_uno.indexOf($('#txtUno__'+i).val())==-1){
											as[j].mount=q_add(dec(as[j].mount),1);
										}
										//as[j].mount=q_add(dec(as[j].mount),dec($('#txtMount__'+i).val()));
										as[j].weight=q_add(dec(as[j].weight),dec($('#txtWeight__'+i).val()));
									}
								}
								if(!is_exists){	
									as.push({
										product:$('#txtProduct__'+i).val(),
										ucolor:$('#txtUcolor__'+i).val(),
										spec:$('#txtSpec__'+i).val(),
										size:$('#txtSize__'+i).val(),
										lengthb:0,//$('#txtLengthb__'+i).val()
										class:$('#txtClass__'+i).val(),
										mount:$('#txtMount__'+i).val(),
										weight:$('#txtWeight__'+i).val(),
										noa:'',//$('#txtOrdeno__'+i).val()
										no2:'',//$('#txtNo2__'+i).val()
										storeno:'7000A', //106/04/11
										store:'智勝-成品', //106/04/11
										item:'1'
									});
								}
								
								tot_uno=tot_uno+($('#txtUno__'+i).val().length>0?',':'')+$('#txtUno__'+i).val();
							}
						}
						
						as.sort(bbssort);
						
						q_gridAddRow(bbsHtm, 'tbbs', 'txtProduct,txtUcolor,txtSpec,txtSize,txtLengthb,txtClass,txtMount,txtWeight,txtOrdeno,txtNo2,txtStoreno,txtStore,txtItem'
						, as.length, as, 'product,ucolor,spec,size,lengthb,class,mount,weight,noa,no2,storeno,store,item', 'txtOrdeno,txtNo2');
						
						refreshBbs();
                	}
                });
                _bbtAssign();
                for (var i = 0; i < q_bbtCount; i++) {
                	//$('#txtProduct__' + i).unbind('focus');
                	$('#txtUno__' + i).unbind('keydown');
                	$('#txtUno__' + i).unbind('change');
                	$('#txtUno__'+i).keydown(function(e) {
						t_IdSeq = -1;
						q_bodyId($(this).attr('id'));
						b_seq = t_IdSeq;
						
						if((q_cur==1 || q_cur==2) && (e.which==13)){
							var t_b_seq=dec(b_seq)+1;
							if(t_b_seq>=q_bbtCount){
								$('#btnPlut').click();
								$('#txtUno__' + b_seq).change();
							}
								
							$('#txtUno__'+t_b_seq).focus();
						}
					});
					$('#txtUno__' + i).change(function() {
						t_IdSeq = -1;
						q_bodyId($(this).attr('id'));
						b_seq = t_IdSeq;
						
						//105/03/31 訂單號碼會打多張訂單編號
						var t_unoorde=$(this).val().substr(0,$(this).val().indexOf('-')==-1?$(this).val().length:$(this).val().indexOf('-'));
						
						if($(this).val().substr(0,1)!='M' && !emp($('#txtOrdeno').val()) && $('#txtOrdeno').val().indexOf(t_unoorde)==-1){
							alert('該批號非同一張訂單號碼!!');
							$(this).val('');
						}
							
						if($(this).val().length>0){
							var t_where = "where=^^ uno='" + $(this).val() + "' and noa!='"+$('#txtNoa').val()+"' ^^";
							q_gt('view_vcct', t_where, 0, 0, 0, "getunovcct_"+b_seq);
						}
					});
					
                }
                $('#lblUno_t').text('領料批號');
                $('#lblProductno_t').text('品號');
                $('#lblProduct_t').text('品名');
                $('#lblUcolor_t').text('類別');
                $('#lblSpec_t').text('材質');
                $('#lblSize_t').text('號數');
                $('#lblLengthb_t').text('米數');
                $('#lblClass_t').text('廠牌');
                $('#lblUnit_t').text('單位');
                $('#lblMount_t').text('領料數');
                $('#lblWeight_t').text('領料重');
                $('#lblMemo_t').text('備註');
                
                bbtsum();
            }
            
            function bbssort(a, b) {
				if (dec(replaceAll(a.size,'#',''))< dec(replaceAll(b.size,'#','')))
					return -1;
				if (dec(replaceAll(a.size,'#',''))> dec(replaceAll(b.size,'#','')))
					return 1;
				if(a.spec< b.spec)
					return -1;
				if(a.spec> b.spec)
					return 1;
				return 0;
			}
            
            function bbtsum() {
            	var tot_mount=0,tot_weight=0,tot_uno='';
                for (var i = 0; i < q_bbtCount; i++) {
                	//105/04/07 改成批號計1件
                	if(!emp($('#txtUno__'+i).val())&& tot_uno.indexOf($('#txtUno__'+i).val())==-1){
                		tot_uno=tot_uno+($('#txtUno__'+i).val().length>0?',':'')+$('#txtUno__'+i).val();
                		tot_mount++;	
                	}
                	
	                //tot_mount=q_add(tot_mount,dec($('#txtMount__'+i).val()));
	                tot_weight=q_add(tot_weight,dec($('#txtWeight__'+i).val()));
				}
				if(tot_mount!=0)
					$('#lblTot_mount').text(FormatNumber(tot_mount));
				else
					$('#lblTot_mount').text('');
				if(tot_weight!=0)
					$('#lblTot_weight').text(FormatNumber(tot_weight));
				else
					$('#lblTot_weight').text('');
            }

			function btnIns() {
				_btnIns();
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val('AUTO');
				$('#txtCno').val(z_cno);
				$('#txtAcomp').val(z_acomp);
				$('#txtDatea').val(q_date());
				$('#cmbTypea').val('1');
				$('#txtPaydate').val('AUTO');
				$('#txtDatea').focus();
				//$('#cmbTaxtype').val('1');
				$('#combAddr').text('');
			}

			function btnModi() {
				/*if (!emp($('#txtPart2').val())){
					alert('由互換出貨轉來禁止直接修改!!');
					return;
				}*/
				
				t_cont1=$('#textQno1').val();
				t_cont2=$('#textQno2').val();
				if (emp($('#txtNoa').val()))
					return;
				Lock(1, {
					opacity : 0
				});
				
				if (!emp($('#txtCustno').val())) {
					var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' order by noq desc ^^";
					q_gt('custms', t_where, 0, 0, 0, "");
				}else{
					$('#combAddr').text('');
				}
				
				var t_where = " where=^^ vccno='" + $('#txtNoa').val() + "'^^";
				q_gt('umms', t_where, 0, 0, 0, 'btnModi', r_accy);
			}

			function btnPrint() {
				q_box('z_vccp_vu.aspx' + "?;;;noa=" + trim($('#txtNoa').val()) + ";" + r_accy, '', "95%", "95%", q_getMsg("popPrint"));
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
				as['typea'] = abbm2['typea'];
				as['mon'] = abbm2['mon'];
				as['noa'] = abbm2['noa'];
				as['datea'] = abbm2['datea'];
				as['custno'] = abbm2['custno'];
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
			
			function bbtSave(as) {
                if (!as['product'] && !as['uno']) {
                    as[bbtKey[1]] = '';
                    return;
                }
                q_nowf();
                return true;
            }

			function q_stPost() {
				t_cont1=t_cont1.length==0?'#non':t_cont1;
				t_cont2=t_cont2.length==0?'#non':t_cont2;
				if(q_cur==3){
					if(t_cont1 != '#non' || t_cont2 != '#non'){
						q_func('qtxt.query.changequatgweight', 'vcc.txt,changequat_vu,' + encodeURI(r_accy) + ';' + encodeURI($('#txtNoa').val())+ ';' + encodeURI(t_cont1)+ ';' + encodeURI(t_cont2));
					}
				}
				if (q_cur == 1 || q_cur == 2) {
					var s2 = xmlString.split(';');
					abbm[q_recno]['accno'] = s2[0];
					$('#txtAccno').val(s2[0]);
					if((!emp($('#textQno1').val()) || !emp($('#textQno2').val()) || t_cont1 != '#non' || t_cont2 != '#non' ))
						q_func('qtxt.query.changequatgweight', 'vcc.txt,changequat_vu,' + encodeURI(r_accy) + ';' + encodeURI($('#txtNoa').val())+ ';' + encodeURI(t_cont1)+ ';' + encodeURI(t_cont2));
				}
				t_cont1='#non',t_cont2='#non';
			}

			function refresh(recno) {
				_refresh(recno);
				HiddenTreat();
				stype_chang();
				refreshBbm();
				refreshBbs();
			}

			function HiddenTreat(){
				var t_quat=$('#txtApvmemo').val().split('##');
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
			
			function stype_chang(){
				if($('#cmbStype').val()=='3'){
					$('.invo').show();
					$('.vcca').hide();
				}else{
					$('.invo').hide();
					$('.vcca').show();
				}
			}

			function readonly(t_para, empty) {
				_readonly(t_para, empty);
				if (t_para) {
					$('#combAddr').attr('disabled', 'disabled');
					$('#btnPack').removeAttr('disabled');
				} else {
					$('#combAddr').removeAttr('disabled');
					if(q_cur==1)
						$('#btnPack').attr('disabled','disabled');
				}
				HiddenTreat();
				//限制帳款月份的輸入 只有在備註的第一個字為*才能手動輸入
				if ($('#txtMemo').val().substr(0,1)=='*')
					$('#txtMon').removeAttr('readonly');
				else
					$('#txtMon').attr('readonly', 'readonly');
				refreshBbm();
				refreshBbs();
				totalreadonly();
			}

			function btnMinus(id) {
				_btnMinus(id);
				sum();
				refreshBbs();
			}

			function btnPlus(org_htm, dest_tag, afield) {
				_btnPlus(org_htm, dest_tag, afield);
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
				if (!emp($('#txtPart2').val())){
					alert('由互換出貨轉來禁止直接刪除!!');
					return;
				}
				t_cont1=$('#textQno1').val();
				t_cont2=$('#textQno2').val();
				if (q_chkClose())
					return;
				Lock(1, {
					opacity : 0
				});
				var t_where = " where=^^ vccno='" + $('#txtNoa').val() + "'^^";
				q_gt('umms', t_where, 0, 0, 0, 'btnDele', r_accy);
			}

			function btnCancel() {
				_btnCancel();
				t_cont1='#non';
				t_cont2='#non';
			}

			function q_popPost(s1) {
				switch (s1) {
					case 'txtCardealno':
						//取得車號下拉式選單
						var thisVal = $('#txtCardealno').val();
						var t_where = "where=^^ noa=N'" + thisVal + "' ^^";
						q_gt('cardeal', t_where, 0, 0, 0, "getCardealCarno");
						break;
					case 'txtCustno':
						if (!emp($('#txtCustno').val())) {
							var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' order by noq desc ^^";
							q_gt('custms', t_where, 0, 0, 0, "");
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
				color: blue;
				font-size: medium;
			}
			.tbbm tr td .lbl.btn {
				color: #4297D7;
				font-weight: bolder;
			}
			.tbbm tr td .lbl.btn:hover {
				color: #FF8F19;
			}
			.txt.c1 {
				width: 98%;
				float: left;
			}
			.txt.c2 {
				width: 30%;
				float: left;
			}
			.txt.c3 {
				width: 68%;
				float: left;
			}
			.txt.c4 {
				width: 49%;
				float: left;
			}
			.txt.c6 {
				width: 25%;
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
			}
			.dbbs {
				width: 100%;
			}
			.tbbs a {
				font-size: medium;
			}
			input[type="text"], input[type="button"] ,select{
				font-size: medium;
			}
			.num {
				text-align: right;
			}
			#dbbt {
                width: 100%;
            }
            #tbbt {
                margin: 0;
                padding: 2px;
                border: 2px pink double;
                border-spacing: 1;
                border-collapse: collapse;
                font-size: medium;
                color: blue;
                background: pink;
                width: 100%;
            }
            #tbbt tr {
                height: 35px;
            }
            #tbbt tr td {
                text-align: center;
                border: 2px pink double;
            }
		</style>
	</head>
	<body>
		<div id="dmain">
			<!--#include file="../inc/toolbar.inc"-->
			<div class="dview" id="dview" >
				<table class="tview" id="tview">
					<tr>
						<td align="center" style="width:5%"><a id='vewChk'> </a></td>
						<td align="center" style="width:5%"><a id='vewType'> </a></td>
						<td align="center" style="width:25%"><a id='vewDatea'> </a></td>
						<td align="center" style="width:25%"><a id='vewNoa'> </a></td>
						<td align="center" style="width:40%"><a id='vewComp'> </a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" style=''/></td>
						<td align="center" id='typea=vcc.typea'>~typea=vcc.typea</td>
						<td align="center" id='datea'>~datea</td>
						<td align="center" id='noa'>~noa</td>
						<td align="center" id='comp,4'>~comp,4</td>
					</tr>
				</table>
			</div>
			<div class='dbbm'>
				<table class="tbbm"  id="tbbm">
					<tr>
						<td style="width: 108px;"><span> </span><a id='lblType' class="lbl"> </a></td>
						<td style="width: 108px;"><select id="cmbTypea"> </select></td>
						<td style="width: 118px;">
							<a id='lblStype' class="lbl" style="float: left;"> </a>
							<span style="float: left;"> </span>
							<select id="cmbStype"> </select>
						</td>
						<td style="width: 108px;"><span> </span><a id='lblDatea' class="lbl"> </a></td>
						<td style="width: 108px;"><input id="txtDatea" type="text"  class="txt c1"/></td>
						<td style="width: 108px;"> </td>
						<td style="width: 108px;"><span> </span><a id='lblNoa' class="lbl"> </a></td>
						<td style="width: 108px;"><input id="txtNoa" type="text" class="txt c1" /></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblAcomp" class="lbl btn"> </a></td>
						<td><input id="txtCno" type="text" class="txt c1"/></td>
						<td><input id="txtAcomp" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblMon' class="lbl"> </a></td>
						<td><input id="txtMon" type="text" class="txt c1"/></td>
						<td> </td>
						<td><span> </span><a id='lblPaydate' class="lbl"> </a></td>
						<td><input id="txtPaydate" type="text"  class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblCust" class="lbl btn"> </a></td>
						<td><input id="txtCustno" type="text" class="txt c1"/></td>
						<td>
							<input id="txtComp" type="text" class="txt c1"/>
							<input id="txtNick" type="hidden" class="txt c1"/>
						</td>
						<td><span> </span><a id='lblPay' class="lbl"> </a></td>
						<td><input id="txtPaytype" type="text" class="txt c1"/></td>
						<td><select id="combPay" style="width: 100%;" onchange='combPay_chg()'> </select></td>
						<td align="right"><input id="btnOrdes" type="button"/></td>
						<td align="right"><input id="btnPack" type="button" value="Packing" style="display: none;"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblTel" class="lbl"> </a></td>
						<td colspan='2'><input id="txtTel" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblFax" class="lbl"> </a></td>
						<td colspan='2'><input id="txtFax" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblTrantype' class="lbl"> </a></td>
						<td><select id="cmbTrantype" style="width: 100%;"> </select></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblAddr" class="lbl"> </a></td>
						<td><input id="txtPost" type="text" class="txt c1"/></td>
						<td colspan='4'><input id="txtAddr" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblOrdeno' class="lbl btn"> </a></td>
						<td><input id="txtOrdeno" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblAddr2' class="lbl"> </a></td>						
						<td colspan='2'><input id="txtAddr2"  type="text" class="txt c1"/></td>
						<td>
							<select id="combAddr" style="width: 20px" onchange='combAddr_chg()'> </select>
							<span> </span><a id='lblSales' class="lbl btn"> </a>
						</td>
						<td><input id="txtSalesno" type="text" class="txt c1"/></td>
						<td><input id="txtSales" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblInvono' class="lbl btn"> </a></td>
						<td><input id="txtInvono" type="text" class="txt c1"/></td>
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
						<td><span> </span><a id="lblCardeal" class="lbl btn"> </a></td>
						<td>
							<input id="txtCardealno" type="text" class="txt c1" style="width: 49%;"/>
							<input id="txtCardeal" type="text" class="txt c1"  style="width: 49%;"/>
						</td>
						<td><a id='lblCarno' class="lbl btn" style="float: left;"> </a><span style="float: left;"> </span>
							<input id="txtCarno"  type="text" class="txt" style="width:60px;float: left;"/>
							<select id="combCarno" style="width: 20px;float: left;"> </select>
						</td>
						<td><span> </span><a id="lblPrice_vu" class="lbl">應付運費單價</a></td>
						<td><input id="txtPrice"  type="text" class="txt num c1"/></td>
						<td>/KG</td>
						<td><span> </span><a id='lblTranmoney' class="lbl"> </a></td>
						<td><input id="txtTranmoney" type="text" class="txt num c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblMoney" class="lbl"> </a></td>
						<td colspan='2'><input id="txtMoney" type="text" class="txt num c1"/></td>
						<td><span> </span><a id='lblTax' class="lbl"> </a></td>
						<td><input id="txtTax" type="text" class="txt num c1 istax"/></td>
						<td>
							<input id="chkAtax" type="checkbox" onchange='sum()' />
							<!--<select id="cmbTaxtype" class="txt c1" onchange='sum()' > </select>-->
						</td>
						<td><span> </span><a id='lblTotal' class="lbl istax"> </a></td>
						<td><input id="txtTotal" type="text" class="txt num c1 istax"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblMemo" class="lbl"> </a></td>
						<td colspan='7'>
							<textarea id="txtMemo" cols="10" rows="5" style="width: 99%;height: 50px;"> </textarea>
							<input id="txtApvmemo" type="hidden" class="txt c1"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id="lblQno1" class="lbl btn">合約號碼</a></td>
						<td colspan='2'><input id="textQno1" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblQweight1" class="lbl">合約重量</a></td>
						<td colspan='2'><input id="textQweight1" type="text" class="txt num c1"/></td>
					</tr>
					<tr style="display: none;">
						<td><span> </span><a id="lblQno2" class="lbl btn">合約2號碼</a></td>
						<td colspan='2'><input id="textQno2" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblQweight2" class="lbl">合約2重量</a></td>
						<td colspan='2'><input id="textQweight2" type="text" class="txt num c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblWorker" class="lbl"> </a></td>
						<td colspan='2'><input id="txtWorker" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblWorker2" class="lbl"> </a></td>
						<td colspan='2'>
							<input id="txtWorker2" type="text" class="txt c1"/>
							<input id="txtPart2" type="hidden"/><!--由GET轉來的單子-->
						</td>
						<td style="display: none;"><span> </span><a id='lblAccc' class="lbl btn"> </a></td>
						<td style="display: none;"><input id="txtAccno" type="text" class="txt c1"/></td>
					</tr>
				</table>
			</div>
		</div>
		<div class='dbbs' style="width: 100%;"><!--1900px-->
			<table id="tbbs" class='tbbs'>
				<tr style='color:White; background:#003366;' >
					<td align="center" style="width:40px;"><input class="btn"  id="btnPlus" type="button" value='＋' style="font-weight: bold;width:" /></td>
					<td align="center" style="width:55px;"><a id='lblNoq_s'> </a></td>
					<!--<td align="center" style="width:200px;"><a id='lblUno_s'> </a></td>-->
					<!--<td align="center" style="width:150px;"><a id='lblProductno_s'> </a></td>-->
					<td align="center" style="width:150px;"><a id='lblProduct_s'> </a></td>
					<td align="center" style="width:160px;"><a id='lblUcolor_s'> </a></td>
					<td align="center" style="width:150px;"><a id='lblSpec_s'> </a></td>
					<td align="center" style="width:100px;"><a id='lblSize_s'> </a></td>
					<td align="center" style="width:100px;"><a id='lblLengthb_s'> </a></td>
					<td align="center" style="width:100px;"><a id='lblClass_s'> </a></td>
					<!--<td align="center" style="width:55px;"><a id='lblUnit_s'> </a></td>-->
					<td align="center" style="width:85px;">
						<a id='lblMount_s'> </a>
						<BR><a id='lblSot_mount'> </a>
					</td>
					<td align="center" style="width:85px;">
						<a id='lblWeight_s'> </a>
						<BR><a id='lblSot_weight'> </a>
					</td>
					<td align="center" style="width:85px;"><a id='lblPrice_s'> </a></td>
					<td align="center" style="width:100px;"><a id='lblTotal_s'> </a></td>
					<td align="center" style="width:150px;"><a id='lblStore_s'> </a><input class="btn"  id="btnStoreCopy" type="button" value='≡' style="font-weight: bold;"  /></td>
					<td align="center" style="width:200px;"><a id=''>對帳單備註</a></td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td align="center"><input class="btn"  id="btnMinus.*" type="button" value='－' style=" font-weight: bold;" /></td>
					<td align="center"><input id="txtNoq.*" type="text" class="txt c1"/></td>
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
					<td>
						<input id="txtSpec.*" type="text" class="txt c1" style="width: 70%;"/>
						<select id="combSpec.*" class="txt" style="width: 20px;"> </select>
					</td>
					<td><input id="txtSize.*" type="text" class="txt c1" /></td>
					<td><input id="txtLengthb.*" type="text" class="txt num c1" /></td>
					<td>
						<input id="txtClass.*" type="text" class="txt c1" style="width: 60%;"/>
						<select id="combClass.*" class="txt" style="width: 20px;"> </select>
					</td>
					<!--<td><input id="txtUnit.*" type="text" class="txt c1"/></td>-->
					<td><input id="txtMount.*" type="text" class="txt num c1"/></td>
					<td><input id="txtWeight.*" type="text" class="txt num c1"/></td>
					<td><input id="txtPrice.*" type="text" class="txt num c1"/></td>
					<td><input id="txtTotal.*" type="text" class="txt num c1"/></td>
					<td>
						<input id="txtStoreno.*" type="text" class="txt c1" style="width: 65%"/>
						<input class="btn"  id="btnStoreno.*" type="button" value='.' style=" font-weight: bold;" />
						<input id="txtStore.*" type="text" class="txt c1"/>
						<input id="txtItem.*" type="hidden"/>
					</td>
					<td>
						<input id="txtMemo.*" type="text" class="txt c1"/>
						<input id="txtOrdeno.*" type="text"  class="txt" style="width:65%;"/>
						<input id="txtNo2.*" type="text" class="txt" style="width:20%;"/>
					</td>
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
		<div id="dbbt" class='dbbt'>
			<table id="tbbt" class="tbbt">
				<tr class="head" style="color:white; background:#003366;">
					<td style="width:20px;"><input id="btnPlut" type="button" style="font-size: medium; font-weight: bold;" value="＋"/></td>
					<td style="width:20px;"> </td>
					<td style="width:200px;">
						1.<a id='lblUno_t'> </a>
						<input id="btnVccttoOrde" type="button" style="font-size: medium; font-weight: bold;" value="2.出貨明細產生"/>
					</td>
					<!--<td style="width:150px;"><a id='lblProductno_t'> </a></td>-->
					<td style="width:100px;"><a id='lblProduct_t'> </a></td>
					<td style="width:150px;"><a id='lblUcolor_t'> </a></td>
					<td style="width:130px;"><a id='lblSpec_t'> </a></td>
					<td style="width:50px;"><a id='lblSize_t'> </a></td>
					<td style="width:70px;"><a id='lblLengthb_t'> </a></td>
					<td style="width:100px;"><a id='lblClass_t'> </a></td>
					<!--<td style="width:55px;"><a id='lblUnit_t'> </a></td>-->
					<td style="width:80px;">
						<a id='lblMount_t'> </a>
						<BR><a id='lblTot_mount'> </a>
					</td>
					<td style="width:100px;">
						<a id='lblWeight_t'> </a>
						<BR><a id='lblTot_weight'> </a>
					</td>
					<td style="text-align: center;"><a id='lblMemo_t'> </a></td>
				</tr>
				<tr>
					<td>
						<input id="btnMinut..*" type="button" style="font-size: medium; font-weight: bold;" value="－"/>
						<input class="txt" id="txtNoq..*" type="text" style="display: none;"/>
					</td>
					<td><a id="lblNo..*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
					<td><input id="txtUno..*" type="text" class="txt c1"/></td>
					<!--<td>
						<input id="txtProductno..*" type="text" class="txt c1" style="width: 83%;"/>
						<input class="btn" id="btnProductno..*" type="button" value='.' style="font-weight: bold;" />
					</td>-->
					<td>
						<input id="txtProduct..*" type="text" class="txt c1" style="width: 90%;"/>
						<select id="combProduct..*" class="txt" style="width: 20px;display: none;"> </select>
					</td>
					<td>
						<input id="txtUcolor..*" type="text" class="txt c1" style="width: 90%;"/>
						<select id="combUcolor..*" class="txt" style="width: 20px;display: none;"> </select>
					</td>
					<td>
						<input id="txtSpec..*" type="text" class="txt c1" style="width: 90%;"/>
						<select id="combSpec..*" class="txt" style="width: 20px;display: none;"> </select>
					</td>
					<td><input id="txtSize..*" type="text" class="txt c1" /></td>
					<td><input id="txtLengthb..*" type="text" class="txt num c1" /></td>
					<td>
						<input id="txtClass..*" type="text" class="txt c1" style="width: 90%;"/>
						<select id="combClass..*" class="txt" style="width: 20px;display: none;"> </select>
					</td>
					<!--<td><input id="txtUnit..*" type="text" class="txt c1"/></td>-->
					<td><input id="txtMount..*" type="text" class="txt c1 num"/></td>
					<td><input id="txtWeight..*" type="text" class="txt c1 num"/></td>
					<td>
						<input id="txtMemo..*" type="text" class="txt c1"/>
						<input id="txtOrdeno..*" type="hidden"/>
						<input id="txtNo2..*" type="hidden"/>
						<input id="txtItemno..*" type="hidden"/>
						<input id="txtItem..*" type="hidden"/>
					</td>
				</tr>
			</table>
		</div>
	</body>
</html>
