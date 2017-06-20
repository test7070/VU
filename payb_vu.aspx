<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
	<head>
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"> </script>
		<script src='../script/qj2.js' type="text/javascript"> </script>
		<script src='qset.js' type="text/javascript"> </script>
		<script src='../script/qj_mess.js' type="text/javascript"> </script>
		<script src='../script/mask.js' type="text/javascript"> </script>
		<script src="../script/qbox.js" type="text/javascript"> </script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">
            this.errorHandler = null;
            
            function onPageError(error) {
                alert("An error occurred:\r\n" + error.Message);
            }

            q_tables = 's';
            var q_name = "payb";
            var q_readonly = ['txtVccno','txtAccno','txtNoa', 'txtMoney', 'txtTax', 'txtDiscount', 'txtTotal', 'txtWorker','txtWorker2'];
            var q_readonlys = ['txtTotal','txtMoney'];
            var bbmNum = [['txtMoney', 10, 0, 1], ['txtTax', 10, 0, 1], ['txtTotal', 10, 0, 1], ['txtDiscount', 10, 0, 1]];
            var bbsNum = [['txtPrice', 10, 2, 1], ['txtDiscount', 10, 0, 1], ['txtMount', 10, 1, 1], ['txtMoney', 10, 0, 1], ['txtTax', 10, 0, 1], ['txtTotal', 10, 0, 1]];
            var bbmMask = [];
            var bbsMask = [];
            q_sqlCount = 6;
            brwCount = -1;
            brwCount2 = 12;
            brwList = [];
            brwNowPage = 0;
            brwKey = 'noa';
            q_desc = 1;
            //ajaxPath = "";
            aPop = new Array(['txtCno', 'lblAcomp', 'acomp', 'noa,acomp', 'txtCno,txtAcomp', 'acomp_b.aspx']
            , ['txtAcc1_', 'btnAcc_', 'acc', 'acc1,acc2', 'txtAcc1_,txtAcc2_', "acc_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + "; ;" + r_accy + '_' + r_cno]
            , ['txtTggno', 'lblTgg', 'tgg', 'noa,comp,nick,paytype', 'txtTggno,txtComp,txtNick,txtPayc', 'tgg_b.aspx']
            , ['txtPayinvo_', '', 'invo', 'noa,comp', 'txtPayinvo_', '']
            , ['txtChgitemno_', 'btnChgitemno_', 'chgitem', 'noa,item,acc1,acc2', 'txtChgitemno_,txtChgitem_,txtAcc1_,txtAcc2_,txtMount_', 'chgitem_b.aspx']
            , ['txtProj_', '', 'proj', 'noa,proj', 'txtProj_', '']
            );
            $(document).ready(function() {
                bbmKey = ['noa'];
                bbsKey = ['noa', 'noq'];
                q_brwCount();
                q_gt(q_name, q_content, q_sqlCount, 1)
            }).mousedown(function (e) {
		        if (!$('#div_row').is(':hidden')) {
					$('#div_row').hide();
		        }
		    });
            
            function main() {
                if (dataErr) {
                    dataErr = false;
                    return;
                }
                mainForm(1);

            }
            
            function pop(form) {
                b_pop = form;
            }
            
            function mainPost() {
                q_getFormat();
                bbmMask = [['txtDatea', r_picd], ['txtMon', r_picm], ['txtVbdate', r_picd], ['txtVedate', r_picd]];
                bbsMask = [['txtDatea', r_picd]];
                q_mask(bbmMask);
                q_gt('acomp', '', 0, 0, 0, "");
                q_gt('part', '', 0, 0, 0, "");
                
                q_cmbParse("cmbKind", q_getPara('payb.kind'), 's');
                
                $("#cmbCno").focus(function() {
                    var len = $(this).children().length > 0 ? $(this).children().length : 1;
                    $(this).attr('size', len + "");
                }).blur(function() {
                    $(this).attr('size', '1');
                });
                
                $("#cmbPartno").focus(function() {
                    var len = $(this).children().length > 0 ? $(this).children().length : 1;
                    $(this).attr('size', len + "");
                }).blur(function() {
                    $(this).attr('size', '1');
                });
                
                $('#txtDatea').change(function() {
					$('#txtMon').val($('#txtDatea').val().substr(0, r_lenm));
					$('#txtVbdate').val($('#txtDatea').val().substr(0, r_lenm)+'/01');
					var medate=q_cdn(q_cdn($('#txtDatea').val().substr(0, r_lenm)+'/01',35).substr(0, r_lenm)+'/01',-1);
					$('#txtVedate').val(medate);
                });

                //........................會計傳票
                $('#lblAccno').click(function() {
                	var t_accy=$('#txtDatea').val().substring(0,r_len);
                	if(r_len==4){
                		t_accy=dec(t_accy)-1911;
                	}
                	
                    q_pop('txtAccno', "accc.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";accc3='" + $('#txtAccno').val() + "';" + t_accy + '_' + r_cno, 'accc', 'accc3', 'accc2', "97%", "1054px", q_getMsg('btnAccc'), true);
                });
                //.........................
                $('#btnTgg').click(function() {
                    q_box('Tgg.aspx' + "?;;;;" + r_accy + ";noa=" + trim($('#txtTggno').val()), '', "95%", "600px", "廠商主檔");
                });
                $('#btnChgitem').click(function() {
                    q_box('chgitem.aspx' + "?;;;;" + r_accy + ";noa=" + trim($('#txtNoa').val()), '', "95%", "600px", "費用主檔");

                });
                
				//上方插入空白行
		        $('#lblTop_row').mousedown(function (e) {
		            if (e.button == 0) {
		                q_bbs_addrow(row_bbsbbt, row_b_seq, 0);
		            }
		        });
		        //下方插入空白行
		        $('#lblDown_row').mousedown(function (e) {
		            if (e.button == 0) {
		                q_bbs_addrow(row_bbsbbt, row_b_seq, 1);
		            }
		        });
            }
            
            function q_boxClose(s2) {
                var ret;
                switch (b_pop) {
                    case q_name + '_s':
                        q_boxClose2(s2);
                        break;
                }
                b_pop = '';
            }

            function q_gtPost(t_name) {
                switch (t_name) {
                	case 'btnDele':
                		var as = _q_appendData("pays", "", true);
                        if (as[0] != undefined) {
                        	var t_msg = "",t_paysale=0;
                        	for(var i=0;i<as.length;i++){
                        		t_paysale = parseFloat(as[i].paysale.length==0?"0":as[i].paysale);
                        		if(t_paysale!=0)
                        			t_msg += String.fromCharCode(13)+'付款單號【'+as[i].noa+'】 '+FormatNumber(t_paysale);
                        	}
                        	if(t_msg.length>0){
                        		alert('已沖帳:'+ t_msg);
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
                        	var t_msg = "",t_paysale=0;
                        	for(var i=0;i<as.length;i++){
                        		t_paysale = parseFloat(as[i].paysale.length==0?"0":as[i].paysale);
                        		if(t_paysale!=0)
                        			t_msg += String.fromCharCode(13)+'付款單號【'+as[i].noa+'】 '+FormatNumber(t_paysale);
                        	}
                        	if(t_msg.length>0){
                        		alert('已沖帳:'+ t_msg);
                        		Unlock(1);
                        		return;
                        	}
                        }
	                	_btnModi();
	                	sum();
	                	Unlock(1);
                		$('#txtMemo').focus();
                		break;
                    case 'part':
                        var as = _q_appendData("part", "", true);
                        if (as[0] != undefined) {
                            var t_item = "";
                            for ( i = 0; i < as.length; i++) {
                                t_item = t_item + (t_item.length > 0 ? ',' : '') + as[i].noa + '@' + as[i].part;
                            }
                            q_cmbParse("cmbPartno", t_item);
                            if (abbm[q_recno] != undefined) {
                                $("#cmbPartno").val(abbm[q_recno].partno);
                            }
                        }
                        break;
                    case 'acomp':
                        var as = _q_appendData("acomp", "", true);
                        if (as[0] != undefined) {
                            var t_item = " @ ";
                            for ( i = 0; i < as.length; i++) {
                                t_item = t_item + (t_item.length > 0 ? ',' : '') + as[i].noa + '@' + as[i].acomp;
                            }
                            q_cmbParse("cmbCno", t_item);
                            if (abbm[q_recno] != undefined) {
                                $("#cmbCno").val(abbm[q_recno].cno);
                            }
                        }
                        break;
                    case q_name:
                        if (q_cur == 4)
                            q_Seek_gtPost();

                        break;
                }  /// end switch
            }
            
			function q_stPost() {
                if (!(q_cur == 1 || q_cur == 2))
                    return false;
                abbm[q_recno]['accno'] = xmlString.split(";")[0];
                $('#txtAccno').val(xmlString.split(";")[0]);
                Unlock(1);
            }
            
            function btnOk() {
            	Lock(1,{opacity:0});
                if ($.trim($('#txtNick').val()).length == 0)
                    $('#txtNick').val($('#txtComp').val());
                $('#txtAcomp').val($('#cmbCno').find(":selected").text());
                $('#txtPart').val($('#cmbPartno').find(":selected").text());

                if($('#txtDatea').val().length == 0 || !q_cd($('#txtDatea').val())){
					alert(q_getMsg('lblDatea')+'錯誤。');
            		Unlock(1);
            		return;
				}
				
                if (!q_cd($('#txtVbdate').val()) || !q_cd($('#txtVedate').val())){
                	alert(q_getMsg('lblVdate')+'錯誤。');
                	Unlock(1); 
                	return; 
                }
               	if ($('#txtMon').val().length > 0 && !(/^[0-9]{4}\/(?:0?[1-9]|1[0-2])$/g).test($('#txtMon').val())) {
                    alert(q_getMsg('lblMon') + '錯誤。');
                    Unlock(1);
                    return;
                }
                
                sum();
                
                if(q_cur ==1){
                	$('#txtWorker').val(r_name);
                }else if(q_cur ==2){
                	$('#txtWorker2').val(r_name);
                }
                
                var t_noa = trim($('#txtNoa').val());
                var t_date = trim($('#txtDatea').val());
                if (t_noa.length == 0 || t_noa == "AUTO")
                    q_gtnoa(q_name, replaceAll(q_getPara('sys.key_payb') + (t_date.length == 0 ? q_date() : t_date), '/', ''));
                else
                    wrServer(t_noa);
            }

            function _btnSeek() {
                if (q_cur > 0 && q_cur < 4)// 1-3
                    return;

                q_box('payb_s.aspx', q_name + '_s', "550px", "550px", q_getMsg("popSeek"));
            }

            function bbsAssign() {
                for (var j = 0; j < q_bbsCount; j++) {
                	$('#lblNo_'+j).text(j+1);	
                	if (!$('#btnMinus_' + j).hasClass('isAssign')) {
                		$('#btnMinus_' + j).click(function() {
							btnMinus($(this).attr('id'));
						}).bind('contextmenu',function(e){ 
							e.preventDefault();
							////////////控制顯示位置
							$('#div_row').css('top', e.pageY);
							$('#div_row').css('left', e.pageX);
							////////////
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							$('#div_row').show();
							row_b_seq = b_seq;
							row_bbsbbt = 'bbs';
						});
                		
                		$('#txtAcc1_' + j).change(function(e) {
		                    var patt = /^(\d{4})([^\.,.]*)$/g;
                    		$(this).val($(this).val().replace(patt,"$1.$2"));
                    		
                    		t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							
							if(!emp($('#txtAcc1_'+b_seq).val())&&$('#txtAcc1_'+b_seq).val().substr(0,4)>='1400' && $('#txtAcc1_'+b_seq).val().substr(0,4)<='1491'){
								q_box("accz.aspx", 'ticket', "95%", "95%", q_getMsg("popAccz"));
							}
							
                		});
                		$('#txtMount_' + j).change(function(e) {
                			t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							
                			$('#txtMoney_'+b_seq).val(FormatNumber(round(q_mul(q_float('txtMount_'+b_seq),q_float('txtPrice_'+b_seq)),0)));
                			if($('#chkAtax_'+b_seq).prop('checked')){
                				$('#txtTax_'+b_seq).val(FormatNumber(round(q_mul(q_float('txtMoney_'+b_seq),0.05),0)));
                			}else{
                				$('#txtTax_'+b_seq).val(0);
                			}
                			$('#txtTotal_'+b_seq).val(FormatNumber(q_sub(q_add(q_float('txtMoney_'+b_seq),q_float('txtTax_'+b_seq)),q_float('txtDiscount_'+b_seq))));
                			
	                        sum();
	                    });
	                    $('#txtPrice_' + j).change(function(e) {
	                    	t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							
                			$('#txtMoney_'+b_seq).val(FormatNumber(round(q_mul(q_float('txtMount_'+b_seq),q_float('txtPrice_'+b_seq)),0)));
                			if($('#chkAtax_'+b_seq).prop('checked')){
                				$('#txtTax_'+b_seq).val(FormatNumber(round(q_mul(q_float('txtMoney_'+b_seq),0.05),0)));
                			}else{
                				$('#txtTax_'+b_seq).val(0);
                			}
                			$('#txtTotal_'+b_seq).val(FormatNumber(q_sub(q_add(q_float('txtMoney_'+b_seq),q_float('txtTax_'+b_seq)),q_float('txtDiscount_'+b_seq))));
	                    	
	                        sum();
	                    });
                		$('#txtMoney_' + j).change(function(e) {
                			
                			t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							
                			if($('#chkAtax_'+b_seq).prop('checked')){
                				$('#txtTax_'+b_seq).val(FormatNumber(round(q_mul(q_float('txtMoney_'+b_seq),0.05),0)));
                			}else{
                				$('#txtTax_'+b_seq).val(0);
                			}
                			$('#txtTotal_'+b_seq).val(FormatNumber(q_sub(q_add(q_float('txtMoney_'+b_seq),q_float('txtTax_'+b_seq)),q_float('txtDiscount_'+b_seq))));
	                        sum();
	                    });
	                    $('#txtTax_' + j).change(function(e) {
	                    	t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							
                			$('#txtTotal_'+b_seq).val(FormatNumber(q_sub(q_add(q_float('txtMoney_'+b_seq),q_float('txtTax_'+b_seq)),q_float('txtDiscount_'+b_seq))));
	                        sum();
	                    });
	                    $('#txtDiscount_' + j).change(function(e) {
	                    	t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							
	                    	$('#txtTotal_'+b_seq).val(FormatNumber(q_sub(q_add(q_float('txtMoney_'+b_seq),q_float('txtTax_'+b_seq)),q_float('txtDiscount_'+b_seq))));
	                        sum();
	                    });
	                    $('#chkAtax_'+j).click(function() {
	                    	invonodisabled();
	                    	t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
	                    	if($('#chkAtax_'+b_seq).prop('checked')){
	                    		$('#txtTax_'+b_seq).val(FormatNumber(round(q_mul(q_float('txtMoney_'+b_seq),0.05),0)));
	                    	}else{
	                    		$('#txtTax_'+b_seq).val(0);
	                    		$('#txtInvono_'+b_seq).val('');
	                    	}

                			$('#txtTotal_'+b_seq).val(FormatNumber(q_sub(q_add(q_float('txtMoney_'+b_seq),q_float('txtTax_'+b_seq)),q_float('txtDiscount_'+b_seq))));
	                    	sum();
						});
                	}
                }
                _bbsAssign();
                invonodisabled();
            }
            
            function invonodisabled() {
            	for (var j = 0; j < q_bbsCount; j++) {
            		if(q_cur==1 || q_cur==2){
	            		if($('#chkAtax_'+j).prop('checked')){
	            			$('#txtInvono_'+j).removeAttr('disabled').css('background','');
	            		}else{
	            			$('#txtInvono_'+j).attr('disabled','disabled').css('background','rgb(237, 237, 238)');
	            		}
            		}
            	}
            }

            function btnIns() {
                _btnIns();
                $('#txtNoa').val('AUTO');
                $('#txtDatea').val(q_date());
                $('#txtDatea').change();
                $('#txtDatea').focus();
                $('#cmbCno')[0].selectedIndex="1";
            }

            function btnModi() {
                if (emp($('#txtNoa').val()))
                    return;
                if (q_chkClose())
             		return;
                Lock(1,{opacity:0});
                var t_where =" where=^^ rc2no='"+ $('#txtNoa').val()+"'^^";
                q_gt('pays', t_where, 0, 0, 0, 'btnModi',r_accy);
            }

            function btnPrint() {
			q_box('z_payb.aspx', '', "95%", "95%", q_getMsg("popPrint"));
            }

            function wrServer(key_value) {
                var i;
                $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
                _btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
            }

            function bbsSave(as) {
                if (as['datea'] =='' && as['chgitemno'] =='' && as['chgitem'] =='' && as['memo'] =='' && as['acc1'] =='' && as['invono'] =='') {
                    as[bbsKey[1]] = '';
                    return;
                }
                q_nowf();
                return true;
            }

            function sum() {
            	var t_money=0,t_total=0,t_tax=0,t_discount=0;
            	var tot_money=0,tot_tax=0,tot_discount=0,tot_total=0;
            	var t_moneys = 0;
            	for (var j = 0; j < q_bbsCount; j++) {
	            	tot_money = tot_money.add(q_float('txtMoney_'+j));
	            	tot_tax = tot_tax.add(q_float('txtTax_'+j));
	            	tot_discount = tot_discount.add(q_float('txtDiscount_'+j));
	            	tot_total = tot_total.add(q_float('txtTotal_'+j));
            	}
                $('#txtMoney').val(FormatNumber(tot_money));
            	$('#txtTax').val(FormatNumber(tot_tax));
            	$('#txtDiscount').val(FormatNumber(tot_discount));
            	$('#txtTotal').val(FormatNumber(tot_total));
            }

            function refresh(recno) {
                _refresh(recno);
            }

            function readonly(t_para, empty) {
                _readonly(t_para, empty);
                invonodisabled();
            }

            function btnMinus(id) {
                _btnMinus(id);
                sum();
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
            	if (q_chkClose())
             		return;
            	Lock(1,{opacity:0});
                var t_where =" where=^^ rc2no='"+ $('#txtNoa').val()+"'^^";
                q_gt('pays', t_where, 0, 0, 0, 'btnDele',r_accy);
            }

            function btnCancel() {
                _btnCancel();
            }
            function FormatNumber(n) {
            	var xx = "";
            	if(n<0){
            		n = Math.abs(n);
            		xx = "-";
            	}     		
                n += "";
                var arr = n.split(".");
                var re = /(\d{1,3})(?=(\d{3})+$)/g;
                return xx+arr[0].replace(re, "$1,") + (arr.length == 2 ? "." + arr[1] : "");
            }
            
            Number.prototype.round = function(arg) {
			    return Math.round(this * Math.pow(10,arg))/ Math.pow(10,arg);
			}
			Number.prototype.div = function(arg) {
			    return accDiv(this, arg);
			}
            function accDiv(arg1, arg2) {
			    var t1 = 0, t2 = 0, r1, r2;
			    try { t1 = arg1.toString().split(".")[1].length } catch (e) { }
			    try { t2 = arg2.toString().split(".")[1].length } catch (e) { }
			    with (Math) {
			        r1 = Number(arg1.toString().replace(".", ""))
			        r2 = Number(arg2.toString().replace(".", ""))
			        return (r1 / r2) * pow(10, t2 - t1);
			    }
			}
			Number.prototype.mul = function(arg) {
			    return accMul(arg, this);
			}
			function accMul(arg1, arg2) {
			    var m = 0, s1 = arg1.toString(), s2 = arg2.toString();
			    try { m += s1.split(".")[1].length } catch (e) { }
			    try { m += s2.split(".")[1].length } catch (e) { }
			    return Number(s1.replace(".", "")) * Number(s2.replace(".", "")) / Math.pow(10, m)
			}
			Number.prototype.add = function(arg) {
		   		return accAdd(arg, this);
			}
			function accAdd(arg1, arg2) {
			    var r1, r2, m;
			    try { r1 = arg1.toString().split(".")[1].length } catch (e) { r1 = 0 }
			    try { r2 = arg2.toString().split(".")[1].length } catch (e) { r2 = 0 }
			    m = Math.pow(10, Math.max(r1, r2))
			    return (arg1 * m + arg2 * m) / m
			}
			Number.prototype.sub = function(arg) {
			    return accSub(this,arg);
			}
			function accSub(arg1, arg2) {
			    var r1, r2, m, n;
			    try { r1 = arg1.toString().split(".")[1].length } catch (e) { r1 = 0 }
			    try { r2 = arg2.toString().split(".")[1].length } catch (e) { r2 = 0 }
			    m = Math.pow(10, Math.max(r1, r2));
			    n = (r1 >= r2) ? r1 : r2;
			    return parseFloat(((arg1 * m - arg2 * m) / m).toFixed(n));
			}
			
			function q_popPost(s1) {
		    	switch (s1) {
		    		case 'txtAcc1_':
		    			if(!emp($('#txtAcc1_'+b_seq).val())&&$('#txtAcc1_'+b_seq).val().substr(0,4)>='1400' && $('#txtAcc1_'+b_seq).val().substr(0,4)<='1491'){
							q_box("accz.aspx", 'ticket', "95%", "95%", q_getMsg("popAccz"));
						}
			        break;
		    	}
			}
			
			var row_bbsbbt = ''; //判斷是bbs或bbt增加欄位
		    var row_b_seq = ''; //判斷第幾個row
		    //插入欄位
		    function q_bbs_addrow(bbsbbt, row, topdown) {
		        //取得目前行
		        var rows_b_seq = dec(row) + dec(topdown);
		        if (bbsbbt == 'bbs') {
		            q_gridAddRow(bbsHtm, 'tbbs', 'txtNoq', 1);
		            //目前行的資料往下移動
		            for (var i = q_bbsCount - 1; i >= rows_b_seq; i--) {
		                for (var j = 0; j < fbbs.length; j++) {
		                    if (i != rows_b_seq)
		                        $('#' + fbbs[j] + '_' + i).val($('#' + fbbs[j] + '_' + (i - 1)).val());
		                    else
		                        $('#' + fbbs[j] + '_' + i).val('');
		                }
		            }
		        }
		        if (bbsbbt == 'bbt') {
		            q_gridAddRow(bbtHtm, 'tbbt', fbbt, 1, '', '', '', '__');
		            //目前行的資料往下移動
		            for (var i = q_bbtCount - 1; i >= rows_b_seq; i--) {
		                for (var j = 0; j < fbbt.length; j++) {
		                    if (i != rows_b_seq)
		                        $('#' + fbbt[j] + '__' + i).val($('#' + fbbt[j] + '__' + (i - 1)).val());
		                    else
		                        $('#' + fbbt[j] + '__' + i).val('');
		                }
		            }
		        }
		        $('#div_row').hide();
		        row_bbsbbt = '';
		        row_b_seq = '';
		    }
		</script>
		<style type="text/css">
            #dmain {
                overflow: hidden;
            }
            .dview {
                float: left;
                width: 390px;
                border-width: 0px;
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
                width: 560px;
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
                width: 13%;
            }
            .tbbm .tdZ {
                width: 1%;
            }
            td .schema {
                display: block;
                width: 95%;
                height: 0px;
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
                width: 100%;
                float: left;
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
            .dbbs {
                width: 100%;
            }
            .tbbs a {
                font-size: medium;
            }
            .tbbs input[type="text"] {
                width: 95%;
            }
            .num {
                text-align: right;
            }
            input[type="text"], input[type="button"], select {
                font-size: medium;
            }
		</style>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	>
		<div id="div_row" style="position:absolute; top:300px; left:500px; display:none; width:150px; background-color: #ffffff; ">
            <table id="table_row"  class="table_row" style="width:100%;" border="1" cellpadding='1'  cellspacing='0'>
                <tr>
                    <td align="center" ><a id="lblTop_row" class="lbl btn">上方插入空白行</a></td>
                </tr>
                <tr>
                    <td align="center" ><a id="lblDown_row" class="lbl btn">下方插入空白行</a></td>
                </tr>
            </table>
        </div>
		<!--#include file="../inc/toolbar.inc"-->
		<div id='dmain' >
			<div class="dview" id="dview">
				<table class="tview" id="tview">
					<tr>
						<td align="center" style="width:20px; color:black;"><a id='vewChk'> </a></td>
						<td align="center" style="width:80px; color:black;"><a id='vewDatea'> </a></td>
						<td align="center" style="width:150px; color:black;"><a id='vewComp'> </a></td>
						<td align="center" style="width:70px; color:black;"><a id='vewTotal'> </a></td>
						<td align="center" style="width:70px; color:black;"><a id='vewUnpay'> </a></td>
					</tr>
					<tr>
						<td >
						<input id="chkBrow.*" type="checkbox" />
						</td>
						<td id="datea" style="text-align: center;">~datea</td>
						<td id="nick" style="text-align: center;">~nick</td>
						<td id="total,0,1" style="text-align: right;">~total,0,1</td>
						<td id="unpay,0,1" style="text-align: right;">~unpay,0,1</td>
					</tr>
				</table>
			</div>
			<div class='dbbm'>
				<table class="tbbm"  id="tbbm">
					<tr style="height:1px;">
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td class="tdZ"> </td>
					</tr>
					<tr>
						<td><span> </span><a id='lblNoa' class="lbl"> </a></td>
						<td><input id="txtNoa"   type="text"  class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblDatea' class="lbl"> </a></td>
						<td><input id="txtDatea"  type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblMon' class="lbl"> </a></td>
						<td><input id="txtMon"  type="text"  class="txt c1" /></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblAcomp" class="lbl btn" > </a></td>
						<td>
							<select id="cmbCno" class="txt c1"> </select>
							<input id="txtAcomp" type="text"  style="display:none;"/>
						</td>
						<td><span> </span><a id="lblPart" class="lbl" > </a></td>
						<td>
							<select id="cmbPartno" class="txt c1"> </select>
							<input id="txtPart"  type="text" style="display: none;"/>
						</td>	
					</tr>
					<tr>
						<td><span> </span><a id="lblTgg"  class="lbl btn"> </a></td>
						<td colspan="3">
							<input id="txtTggno" type="text" style="float:left; width:20%;"/>
							<input id="txtComp"  type="text" style="float:left; width:80%;"/>
							<input id="txtNick"  type="text" style="display:none;"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id='lblPaytype' class="lbl" style="font-size: 14px;">付款方式</a></td>
						<td colspan="3"><input id="txtPayc" type="text" style="float:left; width:99%;"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblVdate'class="lbl" > </a></td>
						<td colspan="2">
							<input id="txtVbdate" type="text"  class="txt c1" style="width: 45%;"/>
							<a class="lbl" style="float: left;">~</a>
							<input id="txtVedate" type="text"  class="txt c1"  style="width: 45%;"/>
						</td>
					</tr>						
					<tr>
						<td><span> </span><a id='lblMoney' class="lbl"> </a></td>
						<td><input id="txtMoney" type="text" class="txt num c1" /></td>
						<td><span> </span><a id='lblTax' class="lbl"> </a></td>
						<td><input id="txtTax" type="text"  class="txt num c1" /></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblDiscount' class="lbl"> </a></td>
						<td><input id="txtDiscount" type="text"  class="txt num c1" /></td>
						<td><span> </span><a id='lblTotal' class="lbl"> </a></td>
						<td><input id="txtTotal" type="text" class="txt num c1" /></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblPic' class="lbl"> </a></td>
						<td><input id="txtPic"  type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblAccno" class="lbl btn"> </a></td>
						<td><input id="txtAccno"  type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblMemo' class="lbl"> </a></td>
						<td colspan="3" ><textarea id="txtMemo" cols="10" rows="5" style="width: 99%; height:50px;"> </textarea></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblWorker' class="lbl"> </a></td>
						<td><input id="txtWorker"  type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblWorker2' class="lbl"> </a></td>
						<td><input id="txtWorker2"  type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td> </td>
						<td colspan="3">
							<input id="btnTgg" type="button" style="float: left;"/>
							<input id="btnChgitem" type="button" style="float: left;" value="費用主檔"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class='dbbs' >
			<table id="tbbs" class='tbbs'  border="1"  cellpadding='2' cellspacing='1'  >
				<tr style='color:white; background:#003366;' >
					<td align="center" style="width:30px;">
					<input class="btn"  id="btnPlus" type="button" value='+' style="font-weight: bold;"  />
					</td>
					<td align="center" style="width:20px;"> </td>
					<td align="center" style="width:90px;"><a id='lblDatea_s'> </a></td>
					<td align="center" style="width:120px;"><a id='lblChgitem'> </a></td>
					<td align="center" ><a>傳票摘要/會計科目</a></td>
					<td align="center" style="width:100px;"><a id='lblMount'> </a></td>
					<td align="center" style="width:120px;"><a id='lblMoneys'> </a></td>
					<td align="center" style="width:30px;"><a>含稅</a></td>
					<td align="center" style="width:130px;"><a id='lblInvonos'> </a><BR><a id='lblTaxs'> </a></td>
					<td align="center" style="width:80px;"><a id='lblTotals'> </a></td>
					<td align="center" style="width:120px;display:none;"><a id='lblBal'> </a></td>
					<td align="center" style="width:150px;"><a id='lblProj_s'> </a></td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td align="center">
						<input class="btn"  id="btnMinus.*" type="button" value='-' style=" font-weight: bold;" />
						<input id="txtNoq.*"  style="display:none;"/>
					</td>
					<td><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
					<td><input id="txtDatea.*" type="text"  style="width: 95%;"/></td>
					<td>
						<input id="txtChgitemno.*" type="text" style="text-align: left; width: 80%;" />
						<input class="btn"  id="btnChgitemno.*" type="button" value='.' style=" font-weight: bold;width: 1%;" />
						<input id="txtChgitem.*" type="text" style="text-align: left; width: 95%;" />
					</td>
					<td>
						<input id="txtMemo.*" type="text" style=" width: 95%;"/>	
						<input class="btn"  id="btnAcc.*" type="button" value='.' style="float: left; font-weight: bold;width:1%;" />
						<input type="text" id="txtAcc1.*"  style="float: left;width:40%;"/>
						<input type="text" id="txtAcc2.*"  style="float: left;width:40%;"/>
					</td>
					<td>
						<input id="txtMount.*" type="text" style="text-align: right; width: 95%;" />
						<input id="txtPrice.*" type="text" style="text-align: right; width: 95%;" />
					</td>
					<td>
						<input id="txtMoney.*" type="text" style="text-align: right; width: 95%;"/>
						<input id="txtDiscount.*" type="text" style="text-align: right; width: 95%;" />
					</td>
					<td align="center"><input id="chkAtax.*" type="checkbox" /></td>
					<td>
						<input id="txtInvono.*" type="text" style="width: 95%;"/>
						<input id="txtTax.*" type="text" style="text-align: right; width: 95%;" />
					</td>
					<td><input id="txtTotal.*" type="text" style="text-align: right; width: 95%;" /></td>
					<td style="display:none"><input id="txtBal.*" type="text" style="width: 95%;" /></td>
					<td><input id="txtProj.*" type="text" style="float: left;"></td>
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>

