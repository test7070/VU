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
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"> </script>
		<script src="css/jquery/ui/jquery.ui.widget.js"> </script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"> </script>
		<script type="text/javascript">
			var q_name = "cuc";
			aPop = new Array();
			var intervalupdate;
			var chk_cucs=[]; //儲存要加工的cucs資料
			var dialog_rep=false;
			
			$(document).ready(function() {
				_q_boxClose();
                q_getId();
                q_gf('', q_name);
                q_gt('ucc', '1=1 ', 0, 0, 0, "");
                q_gt('spec', '1=1 ', 0, 0, 0, "");
                q_gt('color', '1=1 ', 0, 0, 0, "");
				q_gt('class', '1=1 ', 0, 0, 0, "");
				q_gt('mech', '1=1 ', 0, 0, 0, "");
				
				setInterval("dialog_show()",1000*5);
			});
			
			function dialog_show() {
				var t_time=padL(new Date().getHours(), '0', 2)+':'+padL(new Date().getMinutes(),'0',2);
				if(t_time=='17:00' && !dialog_rep){
					$('#dialog').show();
					dialog_rep=true;
				}
				if(t_time!='17:00'){
					dialog_rep=false;
				}
			}
			
			var isupdate=false; //表示更新資料
			function cucsupdata() {
				isupdate=true;
				var bbsrow=document.getElementById("cucs_table").rows.length-1;
				if(bbsrow>0){ //有資料再刷新
					var new_where='1=0';
					for(var i=0;i<bbsrow;i++){
						if(!emp($('#cucs_noa'+i).text()) && new_where.indexOf($('#cucs_noa'+i).text()+$('#cucs_noq'+i).text())==-1)
							new_where=new_where+" or (a.noa+'-'+b.noq='"+$('#cucs_noa'+i).text()+"-"+$('#cucs_noq'+i).text()+"' )";
					}
					var t_where = "where=^^ 1=1 and ("+new_where+") and isnull(a.gen,0)=0 and isnull(b.mins,0)=0 order by b.size,b.spec,b.lengthb desc,b.noa,b.noq ^^";
					var t_where1 = "where[1]=^^ cb.productno2=b.noa and cb.product2=b.noq and case when isnull(ca.itype,'')='' then '1' else ca.itype end ='1' ^^";
					q_gt('cucs_vu', t_where+t_where1, 0, 0, 0,'importcucs', r_accy);
					Lock();
				}
			}
			
			var t_spec='@',t_ucolor='@',t_class='@',t_mech='@',t_ucc='@';
			var bbtaddcount=1;//bbt每次新增五筆
			var isclear=false;
			var stkupdate=0;
			var t_endanoa='',t_endanoq='',t_mins_count=0;
			var t_waste_count=0,t_hours_count=0;
			function q_gfPost() {
				chk_cucs=new Array();
				
				q_getFormat();
                q_langShow();
                q_popAssign();
                $('#textDatea').mask(r_picd);
                $('#textDatea').val(q_date());
                q_cur=2;
                document.title='現場裁剪作業';
                
                if(r_len==4){                	
                	$.datepicker.r_len=4;
                }
                $('#textDatea').datepicker();
				
				//載入案號 資料
                var t_where = "where=^^ 1=1 and isnull(a.gen,0)=0 and isnull(b.mins,0)=0 order by b.size,b.spec,b.lengthb desc,b.noa,b.noq ^^";
                var t_where1 = "where[1]=^^ cb.productno2=b.noa and cb.product2=b.noq and case when isnull(ca.itype,'')='' then '1' else ca.itype end ='1' ^^";
				q_gt('cucs_vu', t_where+t_where1, 0, 0, 0,'init', r_accy);
				
				q_cmbParse("combSize", ',#3,#4,#5,#6,#7,#8,#9,#10,#11,#12,#13,#14,#15,#16');
				q_cmbParse("combOrder",' @ ,memo@備註(標籤)');
				q_cmbParse("combMechno2",'1@1剪,2@2剪,3@3剪,7@7辦公室');
				$('#combOrder').val('memo');//1124預設
				
				if(r_userno.toUpperCase()=='B01'){
					$('#combMechno2').val('1');
				}else if(r_userno.toUpperCase()=='B02'){
					$('#combMechno2').val('2');
				}else if(r_userno.toUpperCase()=='B03'){
					$('#combMechno2').val('3');
				}else{
					$('#combMechno2').val('7');
				}
				
				//關閉彈出視窗
				$('#btnDialog_close').click(function() {
					$('#dialog').hide();
				});
				
				//登出
				$('#logout').click(function() {
					q_logout(q_idr);
				});
				
				//庫存
				$('#btnStk').click(function() {
					//window.open("./z_ucc_vu.aspx"+ "?"+ r_userno + ";" + r_name + ";" + q_id +";;" + r_accy);
					q_box('z_ucc_vu.aspx', 'z_ucc_vu', "95%", "95%", $('#btnStk').val());
				});
				
				//料單報表
				$('#btnCubp').click(function() {
					q_box("z_cubp_vu.aspx?"+ r_userno + ";" + r_name + ";" + q_id +";report=4;" + r_accy, 'z_ucc_vu', "95%", "95%", $('#btnCubp').val());
				});
				
				$('#btnCubp8').click(function() {
					q_box("z_cubp_vu.aspx?"+ r_userno + ";" + r_name + ";" + q_id +";report=8;" + r_accy, 'z_ucc_vu', "95%", "95%", $('#btnCubp8').val());
				});
				
				$('#btnCubp2').click(function() {
					q_box("z_cubp_vu.aspx?"+ r_userno + ";" + r_name + ";" + q_id +";report=2;" + r_accy, 'z_ucc_vu', "95%", "95%", $('#btnCubp2').val());
				});
				
				$('#btnCubp5').click(function() {
					q_box("z_cubp_vu.aspx?"+ r_userno + ";" + r_name + ";" + q_id +";report=5;" + r_accy, 'z_ucc_vu', "95%", "95%", $('#btnCubp5').val());
				});
				
				$('#lblCucnoa').click(function() {
					q_box("cuc_vu_b.aspx?"+ r_userno + ";" + r_name + ";" + q_id +";1=1 and isnull(gen,0)=0 and exists (select * from view_cucs where noa=a.noa and isnull(mins,0)=0) ;" + r_accy, 'cuc_vu_b', "95%", "95%", '加工單');
				});
				
				//匯入
                $('#btnImport').click(function(e) {
                	var t_cucno = $('#combCucno').val();
                	var t_product = $('#combProduct').val();
                	var t_size = $('#combSize').val();
                	var tx_spec = $('#combSpec').val();
                	if(t_cucno.length>0){
                		var t_err = q_chkEmpField([['combMechno', '人員組別']]);
						if (t_err.length > 0) {
				        	alert(t_err);
							return;
						}
                		
	                    var t_where = " 1=1 and isnull(a.gen,0)=0 and isnull(b.mins,0)=0 ";
	                    t_where += q_sqlPara2("a.noa", t_cucno);
	                    t_where += q_sqlPara2("b.product", t_product);//107/04/11
	                    t_where += q_sqlPara2("b.size", t_size);
	                    //t_where += q_sqlPara2("b.spec", tx_spec);
	                    if(tx_spec.length>0){
	                    	t_where += " and b.spec=N'"+tx_spec+"'";
	                    }
	                    
	                    if($('#combOrder').val()=='memo')
	                    	t_where="where=^^"+t_where+" order by isnull(b.memo,''),b.size,b.spec,b.lengthb desc,b.noa,b.noq ^^";
	                    else
	                    	t_where="where=^^"+t_where+" order by b.size,b.spec,b.lengthb desc,b.noa,b.noq ^^";
	                    
	                    var t_where1 = "where[1]=^^ cb.productno2=b.noa and cb.product2=b.noq and case when isnull(ca.itype,'')='' then '1' else ca.itype end ='1' ^^";
	                    
	                    Lock();
	                    isupdate=false;
						q_gt('cucs_vu', t_where+t_where1, 0, 0, 0,'importcucs', r_accy);
						if(chk_cucs.length==0){
							intervalupdate = setInterval(";");
							for (var i = 0 ; i < intervalupdate ; i++) {
							    clearInterval(i); 
							}
							intervalupdate=setInterval("cucsupdata()",1000*60);
							setInterval("dialog_show()",1000*5);
						}
					}
                });
                
                //解除鎖定
                $('#btnCancels').click(function(e) {
                	chk_cucs=new Array();
					q_func('qtxt.query.unlockall', 'cuc_vu.txt,unlockall,'+r_userno.toUpperCase()+';'+r_name);
					intervalupdate = setInterval(";");
					for (var i = 0 ; i < intervalupdate ; i++) {
					    clearInterval(i); 
					}
                	intervalupdate=setInterval("cucsupdata()",1000*60);
                	setInterval("dialog_show()",1000*5);
                });
                
                //完工 清除所有資料
                $('#btnClear').click(function(e) {
                	//clearInterval(intervalupdate);
                	isclear=true;
                	//目前鎖定資料清空
                	chk_cucs=new Array();
                	/*$('#cuct_table .minut').each(function() {
						$(this).click();
                    });*/
                	//初始化cucs
                	var t_where = "where=^^ 1=1 and isnull(a.gen,0)=0 and isnull(b.mins,0)=0 order by b.size,b.spec,b.lengthb desc,b.noa,b.noq^^";
                	var t_where1 = "where[1]=^^ cb.productno2=b.noa and cb.product2=b.noq and case when isnull(ca.itype,'')='' then '1' else ca.itype end ='1' ^^";
					q_gt('cucs_vu', t_where+t_where1, 0, 0, 0,'init', r_accy);
                });
                
                //加工
                $('#btnCub').click(function(e) {
                	var t_err = q_chkEmpField([['textDatea', '加工日'],['combMechno', '人員組別']]);
	                if (t_err.length > 0) {
	                    alert(t_err);
	                    return;
	                }
                	
					if(chk_cucs.length==0){
						alert('無選取加工。');
					}else{
						//先取得最新的資料再判斷是否要轉加工單
						var bbtrow=document.getElementById("cuct_table").rows.length-1;
						var hasbbtnoweight=false; //是否有表身資料 //09/04 有重量才能入庫
						//09/08沒領料仍可入庫但有資料沒重量仍不可入庫
						//10/27領料入庫要獨立分開
                    	/*for(var j=0;j<bbtrow;j++){
                    		var ts_product=$('#textProduct_'+j).val(),ts_ucolor=$('#textUcolor_'+j).val(),ts_spec=$('#textSpec_'+j).val();
							var ts_size=$('#textSize_'+j).val(),ts_lengthb=$('#textLengthb_'+j).val(),ts_class=$('#textClass_'+j).val();
							var ts_gmount=$('#textGmount_'+j).val(),ts_gweight=dec($('#textGweight_'+j).val()),ts_avgweight=dec($('#textAvgweight_'+j).val()),ts_memo=$('#textMemo_'+j).val();
									
							//if(!emp(ts_product) || !emp(ts_ucolor) || !emp(ts_spec) || !emp(ts_size) || 
							//	!emp(ts_lengthb) || !emp(ts_class) || !emp(ts_gmount) || !emp(ts_gweight) || !emp(ts_memo)){
							if((!emp(ts_product) || !emp(ts_ucolor) || !emp(ts_spec) || !emp(ts_size) || !emp(ts_lengthb) || !emp(ts_class))
								&& ts_gweight==0 && ts_avgweight==0){
								hasbbtnoweight=true;
								break;
                    		}
                    	}*/
                    	var bbsrow=document.getElementById("cucs_table").rows.length-1;
                    	t_err='';
                    	for(var j=0;j<bbsrow;j++){
                    		if($('#cucs_chk'+j).prop('checked')){
                    			var t_ordeweight=dec($('#cucs_weight'+j).text());
                    			var t_ordebweight=q_sub(t_ordeweight,dec($('#cucs_eweight'+j).text()));
                    			var t_ordexweight=dec($('#textXweight_'+j).val());
                    			if(q_div(q_add(t_ordebweight,t_ordexweight),t_ordeweight)>=1.03){
                    				t_err=t_err+(t_err.length>0?'\n':'')+'案號【'+$('#cucs_noa'+j).text()+'-'+$('#cucs_noq'+j).text()+'】完工重量超過訂單重量3%，確定是否要入庫?';
                    			}
                    		}
                    	}
						
						if(hasbbtnoweight){
							alert('領料重量等於零。');
						}else{
							if(t_err.length>0){
								if(confirm(t_err)){
									var t_where = "where=^^ 1=1 and isnull(a.gen,0)=0 and isnull(b.mins,0)=0 order by b.size,b.spec,b.lengthb desc,b.noa,b.noq ^^";
									var t_where1 = "where[1]=^^ cb.productno2=b.noa and cb.product2=b.noq and case when isnull(ca.itype,'')='' then '1' else ca.itype end ='1' ^^";
									q_gt('cucs_vu', t_where+t_where1, 0, 0, 0,'tocub', r_accy);
									Lock();
								}
							}else{
								if(confirm("確定是否要入庫?")){//確定轉至加工單
									var t_where = "where=^^ 1=1 and isnull(a.gen,0)=0 and isnull(b.mins,0)=0 order by b.size,b.spec,b.lengthb desc,b.noa,b.noq ^^";
									var t_where1 = "where[1]=^^ cb.productno2=b.noa and cb.product2=b.noq and case when isnull(ca.itype,'')='' then '1' else ca.itype end ='1' ^^";
									q_gt('cucs_vu', t_where+t_where1, 0, 0, 0,'tocub', r_accy);
									Lock();
								}
							}
						}
					}
                });
                
                //107/05/31 預設 先關閉 成型和車牙欄位
                $('#btnFhide1').click(function() {
                	if($('#btnFhide1').val()=='成型顯示'){
                		$('#btnFhide1').val('成型隱藏');
                	}else{
                		$('#btnFhide1').val('成型顯示');
                	}
                	cucs_refresh();
				});
				
				$('#btnFhide2').click(function() {
                	if($('#btnFhide2').val()=='車牙顯示'){
                		$('#btnFhide2').val('車牙隱藏');
                	}else{
                		$('#btnFhide2').val('車牙顯示');
                	}
                	cucs_refresh();
				});
                                
                //--cuct內容&事件---------------------------------------
				var string = "<table id='cuct_table' style='width:1240px;word-break:break-all;'>";
				string+='<tr id="cuct_header">';
				string+='<td id="cuct_plut" align="center" style="width:40px; color:black;"><input id="btnPlut" type="button" style="font-size: medium; font-weight: bold;" value="＋"/></td>';
				string+='<td id="cuct_product" align="center" style="width:110px; color:black;">品名</td>';
				string+='<td id="cuct_ucolor" align="center" style="width:170px; color:black;">類別</td>';
				string+='<td id="cuct_spec" align="center" style="width:140px; color:black;">材質</td>';
				string+='<td id="cuct_size" align="center" style="width:80px; color:black;">號數</td>';
				string+='<td id="cuct_lengthb" align="center" style="width:80px; color:black;">米數</td>';
				string+='<td id="cuct_class" align="center" style="width:100px; color:black;">廠牌</td>';
				string+='<td id="cuct_gmount" align="center" style="width:80px; color:black;">領料件數</td>';
				string+='<td id="cuct_gweight" align="center" style="width:90px; color:black;">領料重量</td>';
				string+='<td id="cuct_avgweight" align="center" style="width:90px; color:black;">均重</td>';
				string+='<td id="cuct_memo" align="center" style="width:220px; color:black;">備註&nbsp;&nbsp;<input id="btnCubt" type="button" style="font-size: medium; font-weight: bold;" value="領料"/></td>';
				string+='</tr>';
				string+='</table>';
				$('#cuct').html(string);
				
                //事件    
				$('#btnPlut').click(function() {
					var now_count=document.getElementById("cuct_table").rows.length-1;	
                   	t_color = ['DarkBlue','DarkRed'];
                   	var string='';
					for(var i=now_count;i<(now_count+bbtaddcount);i++){
	    				string+='<tr id="cuct_tr'+i+'">';
	    				string+='<td style="text-align: center;"><input id="btnMinut_'+i+'" class="minut" type="button" style="font-size: medium; font-weight: bold;" value="－"/></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textProduct_'+i+'"  type="text" class="txt c3" value="鋼筋" /><select id="combProduct_'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textUcolor_'+i+'"  type="text" class="txt c3" value="板料" /><select id="combUcolor_'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textSpec_'+i+'"  type="text" class="txt c3" /><select id="combSpec_'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textSize_'+i+'"  type="text" class="txt c3 sizea" style="width:50%;" /><select id="combSize_'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textLengthb_'+i+'"  type="text" class="txt num c1" /></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textClass_'+i+'"  type="text" class="txt c3" /><select id="combClass_'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textGmount_'+i+'"  type="text" class="txt num c1" /><a id="lblMount_'+i+'" style="display:none;"></a></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textGweight_'+i+'"  type="text" class="txt num c1" /><a id="lblWeight_'+i+'" style="display:none;"></a></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textAvgweight_'+i+'"  type="text" class="txt num c1" disabled="disabled" /></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textMemo_'+i+'"  type="text" class="txt c1" /></td>';
	    				string+='</tr>';
					}
					$('#cuct_table').append(string);
					
					//事件
					//下拉事件
					$('#cuct_table .comb').unbind("change");
                    $('#cuct_table .comb').each(function(index) {
						$(this).text(''); //清空資料
						//帶入選項值
						var n=$(this).attr('id').split('_')[1];
						var objname=$(this).attr('id').split('_')[0];
						if(objname=='combProduct'){
							q_cmbParse("combProduct_"+n, ',鋼筋,鐵線');
						}
						if(objname=='combUcolor'){
							q_cmbParse("combUcolor_"+n, ',板料');
						}
						if(objname=='combSpec'){
							q_cmbParse("combSpec_"+n, t_spec);
						}
						if(objname=='combClass'){
							q_cmbParse("combClass_"+n, t_class);
						}
						if(objname=='combSize'){
							q_cmbParse("combSize_"+n, ',#3,#4,#5,#6,#7,#8,#9,#10,#11,#12,#13,#14,#15,#16');
						}
						
						$(this).change(function() {
							var textnames=replaceAll(objname,'comb','text')
							$('#'+textnames+'_'+n).val($('#'+objname+'_'+n).find("option:selected").text());
							$('#'+objname+'_'+n).val('');
							
							//變動均價
							if(dec($('#textGmount_'+n).val())!=0 || dec($('#textGweight_'+n).val())!=0){
								var x_product=$('#textProduct_'+n).val();
								var x_ucolor=$('#textUcolor_'+n).val();
								var x_spec=$('#textSpec_'+n).val();
								var x_size=$('#textSize_'+n).val();
								var x_lengthb=$('#textLengthb_'+n).val();
								var x_class=$('#textClass_'+n).val();
								var x_edate=$('#textDatea').val();
								if((x_product.length>0 || x_ucolor.length>0 || x_spec.length>0 || x_size.length>0 || x_lengthb.length>0 || x_class.length>0) && x_edate.length>0){
									x_product=emp($('#textProduct_'+n).val())?'#non':$('#textProduct_'+n).val();
									x_ucolor=emp($('#textUcolor_'+n).val())?'#non':$('#textUcolor_'+n).val();
									x_spec=emp($('#textSpec_'+n).val())?'#non':$('#textSpec_'+n).val();
									x_size=emp($('#textSize_'+n).val())?'#non':$('#textSize_'+n).val();
									x_lengthb=emp($('#textLengthb_'+n).val())?'#non':$('#textLengthb_'+n).val();
									x_class=emp($('#textClass_'+n).val())?'#non':$('#textClass_'+n).val();
									x_edate=emp($('#textDatea').val())?q_date():$('#textDatea').val();
									q_func('qtxt.query.getweight_'+n, 'cuc_vu.txt,stk_vu,'+x_product+';'+x_ucolor+';'+x_spec+';'+x_size+';'+x_lengthb+';'+x_class+';'+x_edate+';1');
								}
							}
						});
                    });
                    
                    //清空
                    $('#cuct_table .minut').unbind("click");
                    $('#cuct_table .minut').each(function(index) {
						$(this).click(function() {
							var ns=$(this).attr('id').split('_')[1];
							$('#cuct_tr'+ns+' input[type="text"]').val('');
						});
                    });
                    				
					//所有欄位text
					$('#cuct_table input[type="text"]').unbind("change");
					$('#cuct_table input[type="text"]').unbind("keyup");
					$('#cuct_table input[type="text"]').unbind("focusin");
					$('#cuct_table input[type="text"]').each(function() {
						var objname=$(this).attr('id').split('_')[0];
						var n=$(this).attr('id').split('_')[1];
						
						//只能輸入數值
						if(objname=='textLengthb' || objname=='textGmount' || objname=='textGweight'){
							$(this).keyup(function(e) {
								if(e.which>=37 && e.which<=40){return;}
								var tmp=$(this).val();
								tmp=tmp.match(/\d{1,}\.{0,1}\d{0,}/);
								$(this).val(tmp);
							});
						}
						//立刻讀均重
						if(objname=='textGmount' ){ //10/20 件數輸入才檢查庫存其餘欄位不用檢查庫存 || objname=='textGweight'
							$(this).focusin(function() {
								var x_product=$('#textProduct_'+n).val();
								var x_ucolor=$('#textUcolor_'+n).val();
								var x_spec=$('#textSpec_'+n).val();
								var x_size=$('#textSize_'+n).val();
								var x_lengthb=$('#textLengthb_'+n).val();
								var x_class=$('#textClass_'+n).val();
								var x_edate=$('#textDatea').val();
								if((x_product.length>0 || x_ucolor.length>0 || x_spec.length>0 || x_size.length>0 || x_lengthb.length>0 || x_class.length>0) && x_edate.length>0){
									x_product=emp($('#textProduct_'+n).val())?'#non':$('#textProduct_'+n).val();
									x_ucolor=emp($('#textUcolor_'+n).val())?'#non':$('#textUcolor_'+n).val();
									x_spec=emp($('#textSpec_'+n).val())?'#non':$('#textSpec_'+n).val();
									x_size=emp($('#textSize_'+n).val())?'#non':$('#textSize_'+n).val();
									x_lengthb=emp($('#textLengthb_'+n).val())?'#non':$('#textLengthb_'+n).val();
									x_class=emp($('#textClass_'+n).val())?'#non':$('#textClass_'+n).val();
									x_edate=emp($('#textDatea').val())?q_date():$('#textDatea').val();
									q_func('qtxt.query.getweight_'+n, 'cuc_vu.txt,stk_vu,'+x_product+';'+x_ucolor+';'+x_spec+';'+x_size+';'+x_lengthb+';'+x_class+';'+x_edate+';1');
								}
							});
						}
						//變動事件
						$(this).change(function() {
							//變動均價 //10/20 件數輸入才檢查庫存其餘欄位不用檢查庫存 || dec($('#textGweight_'+n).val())!=0
							if(dec($('#textGmount_'+n).val())!=0){
								var x_product=$('#textProduct_'+n).val();
								var x_ucolor=$('#textUcolor_'+n).val();
								var x_spec=$('#textSpec_'+n).val();
								var x_size=$('#textSize_'+n).val();
								var x_lengthb=$('#textLengthb_'+n).val();
								var x_class=$('#textClass_'+n).val();
								var x_edate=$('#textDatea').val();
								if((x_product.length>0 || x_ucolor.length>0 || x_spec.length>0 || x_size.length>0 || x_lengthb.length>0 || x_class.length>0) && x_edate.length>0){
									x_product=emp($('#textProduct_'+n).val())?'#non':$('#textProduct_'+n).val();
									x_ucolor=emp($('#textUcolor_'+n).val())?'#non':$('#textUcolor_'+n).val();
									x_spec=emp($('#textSpec_'+n).val())?'#non':$('#textSpec_'+n).val();
									x_size=emp($('#textSize_'+n).val())?'#non':$('#textSize_'+n).val();
									x_lengthb=emp($('#textLengthb_'+n).val())?'#non':$('#textLengthb_'+n).val();
									x_class=emp($('#textClass_'+n).val())?'#non':$('#textClass_'+n).val();
									x_edate=emp($('#textDatea').val())?q_date():$('#textDatea').val();
									q_func('qtxt.query.getweight_'+n, 'cuc_vu.txt,stk_vu,'+x_product+';'+x_ucolor+';'+x_spec+';'+x_size+';'+x_lengthb+';'+x_class+';'+x_edate+';1');
								}
							}
							//號數
							if(objname=='textSize'){
								if ($(this).val().substr(0, 1) != '#' &&!emp($(this).val()))
                        		$(this).val('#' + $(this).val());
							}
						});
						
					});
					
					//移動下一格
					var SeekF= new Array();
					$('input:text,select').each(function() {
						if($(this).attr('disabled')!='disabled')
							SeekF.push($(this).attr('id'));
					});
					$('input:text,select').each(function() {
						$(this).bind('keydown', function(event) {
							if( event.which == 13 || event.which == 40) {
								$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1]).focus();
								$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1]).select();
							}
						});
					});
				});
				
				$('#btnCubt').click(function() {
					var t_err = q_chkEmpField([['textDatea', '加工日'],['combMechno', '人員組別']]);
	                if (t_err.length > 0) {
	                    alert(t_err);
	                    return;
	                }
	                //判斷庫存
	                var bbtrow=document.getElementById("cuct_table").rows.length-1;
	                var has_get=false;
	                for(var j=0;j<bbtrow;j++){
		                if(dec($('#textGmount_'+j).val())!=0 || dec($('#textGweight_'+j).val())!=0){
							var x_product=$('#textProduct_'+j).val();
							var x_ucolor=$('#textUcolor_'+j).val();
							var x_spec=$('#textSpec_'+j).val();
							var x_size=$('#textSize_'+j).val();
							var x_lengthb=$('#textLengthb_'+j).val();
							var x_class=$('#textClass_'+j).val();
							var x_edate=$('#textDatea').val();
							if((x_product.length>0 || x_ucolor.length>0 || x_spec.length>0 || x_size.length>0 || x_lengthb.length>0 || x_class.length>0) && x_edate.length>0){
								x_product=emp($('#textProduct_'+j).val())?'#non':$('#textProduct_'+j).val();
								x_ucolor=emp($('#textUcolor_'+j).val())?'#non':$('#textUcolor_'+j).val();
								x_spec=emp($('#textSpec_'+j).val())?'#non':$('#textSpec_'+j).val();
								x_size=emp($('#textSize_'+j).val())?'#non':$('#textSize_'+j).val();
								x_lengthb=emp($('#textLengthb_'+j).val())?'#non':$('#textLengthb_'+j).val();
								x_class=emp($('#textClass_'+j).val())?'#non':$('#textClass_'+j).val();
								x_edate=emp($('#textDatea').val())?q_date():$('#textDatea').val();
								q_func('qtxt.query.cuctstkupdate_'+j, 'cuc_vu.txt,stk_vu,'+x_product+';'+x_ucolor+';'+x_spec+';'+x_size+';'+x_lengthb+';'+x_class+';'+x_edate+';1');
								stkupdate++;
							}
							has_get=true;
						}
					}
					if(!has_get)
						alert('領料重量等於0!!');
				});
				
				$('#btnPlut').click();
				
				//浮動表頭
				var string = "<div id='cuct_float' style='position:absolute;display:block;left:0px; top:0px;'>";
				string+="<table id='cuct_table2' style='width:1240px;border-bottom: none;'>";
				string+='<tr id="cuct_header">';
				string+='<td id="cuct_plut" align="center" style="width:40px; color:black;"><input id="btnPlut2" type="button" style="font-size: medium; font-weight: bold;" value="＋"/></td>';
				string+='<td id="cuct_product" align="center" style="width:110px; color:black;">品名</td>';
				string+='<td id="cuct_ucolor" align="center" style="width:170px; color:black;">類別</td>';
				string+='<td id="cuct_spec" align="center" style="width:140px; color:black;">材質</td>';
				string+='<td id="cuct_size" align="center" style="width:80px; color:black;">號數</td>';
				string+='<td id="cuct_lengthb" align="center" style="width:80px; color:black;">米數</td>';
				string+='<td id="cuct_class" align="center" style="width:100px; color:black;">廠牌</td>';
				string+='<td id="cuct_gmount" align="center" style="width:80px; color:black;">領料件數</td>';
				string+='<td id="cuct_gweight" align="center" style="width:90px; color:black;">領料重量</td>';
				string+='<td id="cuct_avgweight" align="center" style="width:90px; color:black;">均重</td>';
				string+='<td id="cuct_memo" align="center" style="width:220px; color:black;">備註&nbsp;&nbsp;<input id="btnCubt2" type="button" style="font-size: medium; font-weight: bold;" value="領料"/><input type="button" id="btnCub_nouno" value="條碼領料" style="width:80px;font-size: medium; font-weight: bold"/></td>';
				string+='</tr>';
				string+='</table>';
				$('#cuct').append(string);
				
				$('#btnPlut2').click(function() {
					$('#btnPlut').click();
				});
				$('#btnCubt2').click(function() {
					$('#btnCubt').click();
				});
				
				$('#btnCub_nouno').click(function(e) {
					$('#div_nouno').css('top',($('#btnCub_nouno').offset().top-$('#div_nouno').height())+'px');
					$('#div_nouno').css('left',($('#btnCub_nouno').offset().left-$('#div_nouno').width())+'px');
					$('#textNouno').val('');
					$('#div_nouno').show();
					$('#textNouno').focus();
				});
				$('#textNouno').click(function() {
                	q_msg($(this),'多批號領料請用,隔開');
				}).focus(function() {
					$(this).val('');
				});
				
				$('#btnOk_div_nouno').click(function() {
					var t_err = q_chkEmpField([['combMechno', '人員組別']]);
	                if (t_err.length > 0) {
	                    alert(t_err);
	                    return;
	                }
	                
					var t_nouno=$.trim($('#textNouno').val());
					if(t_nouno.length>0){
						t_nouno=t_nouno.split(',');
						var t_where="";
						for (var i=0;i<t_nouno.length;i++){
							t_where=t_where+(t_where.length>0?" or ":"")+"uno='"+t_nouno[i]+"'";
						}
						var t_where = "where=^^ ("+t_where+") ^^";
						q_gt('view_cubs', t_where, 0, 0, 0, "nouno_getuno", r_accy);
					}
				});
				$('#btnClose_div_nouno').click(function() {
					$('#textNouno').val('');
                	$('#div_nouno').hide();
				});
				
				//設定滾動條移動時浮動表頭與div的距離
				$('#cuct').scroll(function(){
					$('#cuct_float').css('top',$(this).scrollTop()+"px")
				});
				
				//--cucu內容&事件---------------------------------------
				var string = "<table id='cucu_table' style='width:1240px;word-break:break-all;'>";
				string+='<tr id="cucu_header">';
				string+='<td id="cucu_plut" align="center" style="width:40px; color:black;"><input id="btnPluu" type="button" style="font-size: medium; font-weight: bold;" value="＋"/></td>';
				string+='<td id="cucu_product" align="center" style="width:110px; color:black;">品名</td>';
				string+='<td id="cucu_ucolor" align="center" style="width:170px; color:black;">類別</td>';
				string+='<td id="cucu_spec" align="center" style="width:140px; color:black;">材質</td>';
				string+='<td id="cucu_size" align="center" style="width:80px; color:black;">號數</td>';
				string+='<td id="cucu_lengthb" align="center" style="width:80px; color:black;">米數</td>';
				string+='<td id="cucu_class" align="center" style="width:100px; color:black;">廠牌</td>';
				string+='<td id="cucu_mount" align="center" style="width:80px; color:black;">件數</td>';
				string+='<td id="cucu_hmount" align="center" style="width:90px; color:black;">支數</td>';
				string+='<td id="cucu_weight" align="center" style="width:90px; color:black;">重量</td>';
				string+='<td id="cucu_memo" align="center" style="width:220px; color:black;">備註&nbsp;&nbsp;<input id="btnCubs" type="button" style="font-size: medium; font-weight: bold;" value="餘料入庫"/></td>';
				string+='</tr>';
				string+='</table>';
				$('#cucu').html(string);
				
                //事件    
				$('#btnPluu').click(function() {
					var now_count=document.getElementById("cucu_table").rows.length-1;	
                   	t_color = ['DarkBlue','DarkRed'];
                   	var string='';
					for(var i=now_count;i<(now_count+bbtaddcount);i++){
	    				string+='<tr id="cucu_tr'+i+'">';
	    				string+='<td style="text-align: center;"><input id="btnMinut__'+i+'" class="minut" type="button" style="font-size: medium; font-weight: bold;" value="－"/></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textProduct__'+i+'"  type="text" class="txt c3" value="鋼筋"/><select id="combProduct__'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textUcolor__'+i+'"  type="text" class="txt c3" value="" /><select id="combUcolor__'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textSpec__'+i+'"  type="text" class="txt c3" /><select id="combSpec__'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textSize__'+i+'"  type="text" class="txt c3 sizea" style="width:50%;" /><select id="combSize__'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textLengthb__'+i+'"  type="text" class="txt num c1" /></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textClass__'+i+'"  type="text" class="txt c3" /><select id="combClass__'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textImount__'+i+'"  type="text" class="txt num c1" /></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textIhmount__'+i+'"  type="text" class="txt num c1" /></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textIweight__'+i+'"  type="text" class="txt num c1" /></td>';
	    				string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textMemo__'+i+'"  type="text" class="txt c1" /></td>';
	    				string+='</tr>';
					}
					$('#cucu_table').append(string);
					
					//事件
					//下拉事件
					$('#cucu_table .comb').unbind("change");
                    $('#cucu_table .comb').each(function(index) {
						$(this).text(''); //清空資料
						//帶入選項值
						var n=$(this).attr('id').split('__')[1];
						var objname=$(this).attr('id').split('__')[0];
						if(objname=='combProduct'){
							q_cmbParse("combProduct__"+n, q_getPara('vccs_vu.product'));
						}
						if(objname=='combUcolor'){
							q_cmbParse("combUcolor__"+n, ',定尺,板料,亂尺');
						}
						if(objname=='combSpec'){
							q_cmbParse("combSpec__"+n, t_spec);
						}
						if(objname=='combClass'){
							q_cmbParse("combClass__"+n, t_class);
						}
						if(objname=='combSize'){
							q_cmbParse("combSize__"+n, ',#3,#4,#5,#6,#7,#8,#9,#10,#11,#12,#13,#14,#15,#16');
						}
						
						$(this).change(function() {
							var textnames=replaceAll(objname,'comb','text')
							$('#'+textnames+'__'+n).val($('#'+objname+'__'+n).find("option:selected").text());
							$('#'+objname+'__'+n).val('');
						});
                    });
                    
                    //清空
                    $('#cucu_table .minut').unbind("click");
                    $('#cucu_table .minut').each(function(index) {
						$(this).click(function() {
							var ns=$(this).attr('id').split('__')[1];
							$('#cucu_tr'+ns+' input[type="text"]').val('');
						});
                    });
                    				
					//所有欄位text
					$('#cucu_table input[type="text"]').unbind("change");
					$('#cucu_table input[type="text"]').unbind("keyup");
					$('#cucu_table input[type="text"]').unbind("focusin");
					$('#cucu_table input[type="text"]').each(function() {
						var objname=$(this).attr('id').split('__')[0];
						var n=$(this).attr('id').split('__')[1];
						
						//只能輸入數值
						if(objname=='textLengthb' || objname=='textImount' || objname=='textIhmount' || objname=='textIweight'){
							$(this).keyup(function(e) {
								if(e.which>=37 && e.which<=40){return;}
								var tmp=$(this).val();
								tmp=tmp.match(/\d{1,}\.{0,1}\d{0,}/);
								$(this).val(tmp);
							});
						}
						//變動事件
						$(this).change(function() {
							//號數
							if(objname=='textSize'){
								if ($(this).val().substr(0, 1) != '#' &&!emp($(this).val()))
                        		$(this).val('#' + $(this).val());
							}
							
							if(objname=='textIhmount' || objname=='textSize' || objname=='textLengthb'){
								var t_siez=replaceAll($('#textSize__'+n).val(),'#','');
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
				            	
				            	var t_lengthb=dec($('#textLengthb__'+n).val());
				            	var t_mount1=dec($('#textIhmount__'+n).val());
				            	
				            	$('#textIweight__'+n).val(round(q_mul(q_mul(t_weight,t_lengthb),t_mount1),0));
							}
						});
						
					});
					
					//移動下一格
					var SeekF= new Array();
					$('input:text,select').each(function() {
						if($(this).attr('disabled')!='disabled')
							SeekF.push($(this).attr('id'));
					});
					$('input:text,select').each(function() {
						$(this).bind('keydown', function(event) {
							if( event.which == 13 || event.which == 40) {
								$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1]).focus();
								$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1]).select();
							}
						});
					});
				});
				
				$('#btnCubs').click(function() {
					var t_err = q_chkEmpField([['textDatea', '加工日'],['combMechno', '人員組別']]);
	                if (t_err.length > 0) {
	                    alert(t_err);
	                    return;
	                }
	                //入庫
	                t_err='';
	                var ts_bbu='';
	                var bburow=document.getElementById("cucu_table").rows.length-1;
					var hasbbu=false;
					var t_datea=emp($('#textDatea').val())?'#non':$('#textDatea').val();
	                var t_mechno=emp($('#combMechno').val())?'#non':$('#combMechno').val();
	                var t_memo=emp($('#textMemo').val())?'#non':$('#textMemo').val();
					for(var j=0;j<bburow;j++){
	                    var ts_product=$('#textProduct__'+j).val();
		                var ts_ucolor=$('#textUcolor__'+j).val();
						var ts_spec=$('#textSpec__'+j).val();
						var ts_size=$('#textSize__'+j).val();
						var ts_lengthb=$('#textLengthb__'+j).val();
						var ts_class=$('#textClass__'+j).val();
						var ts_imount=$('#textImount__'+j).val();
						var ts_ihmount=$('#textIhmount__'+j).val();
						var ts_iweight=$('#textIweight__'+j).val();
						var ts_memo=$('#textMemo__'+j).val();
																
						if(!emp(ts_product) || !emp(ts_ucolor) || !emp(ts_spec) || !emp(ts_size) || !emp(ts_lengthb) || !emp(ts_class)){
							hasbbu=true; //有資料
							if((ts_ucolor=='定尺' || ts_ucolor=='板料') && dec(ts_lengthb)==0){
								t_err=t_err+(t_err.length>0?'\n':'')+('第'+(j+1)+'項 '+ts_product+' '+ts_ucolor+' 米數為0');
							}
							
							if (dec(ts_imount)>0 && dec(ts_iweight)>0){ //件數重量>0
								ts_bbu=ts_bbu
								+ts_product+"^@^"
								+ts_ucolor+"^@^"
								+ts_spec+"^@^"
								+ts_size+"^@^"
								+dec(ts_lengthb)+"^@^"
								+ts_class+"^@^"
								+dec(ts_imount)+"^@^"
								+dec(ts_ihmount)+"^@^"
								+dec(ts_iweight)+"^@^"
								+ts_memo+"^@^"
								+"^#^";
		                   	}
						}
					}
					if(t_err.length>0){
						alert(t_err);
					}else if(!hasbbu){
						alert('無入庫資料');
					}else if(ts_bbu.length==0){
	                   	alert('入庫件數或重量等於零。');
					}else{
	                   	if(confirm("確認要入庫?")){
	                   		Lock();
		                   	q_func('qtxt.query.cucutocubs', 'cuc_vu.txt,cucutocubs,'
							+r_accy+';'+t_datea+';'+t_mechno+';'+t_memo+';'+r_userno.toUpperCase()+';'+r_name+';'+ts_bbu+';1');
						}
					}
				});
				
				$('#btnPluu').click();
				
				//浮動表頭
				var string = "<div id='cucu_float' style='position:absolute;display:block;left:0px; top:0px;'>";
				string+="<table id='cucu_table2' style='width:1240px;border-bottom: none;'>";
				string+='<tr id="cucu_header">';
				string+='<td id="cucu_plut" align="center" style="width:40px; color:black;"><input id="btnPluu2" type="button" style="font-size: medium; font-weight: bold;" value="＋"/></td>';
				string+='<td id="cucu_product" align="center" style="width:110px; color:black;">品名</td>';
				string+='<td id="cucu_ucolor" align="center" style="width:170px; color:black;">類別</td>';
				string+='<td id="cucu_spec" align="center" style="width:140px; color:black;">材質</td>';
				string+='<td id="cucu_size" align="center" style="width:80px; color:black;">號數</td>';
				string+='<td id="cucu_lengthb" align="center" style="width:80px; color:black;">米數</td>';
				string+='<td id="cucu_class" align="center" style="width:100px; color:black;">廠牌</td>';
				string+='<td id="cucu_mount" align="center" style="width:80px; color:black;">件數</td>';
				string+='<td id="cucu_hmount" align="center" style="width:90px; color:black;">支數</td>';
				string+='<td id="cucu_weight" align="center" style="width:90px; color:black;">重量</td>';
				string+='<td id="cucu_memo" align="center" style="width:220px; color:black;">備註&nbsp;&nbsp;<input id="btnCubs2" type="button" style="font-size: medium; font-weight: bold;" value="餘料入庫"/></td>';
				string+='</tr>';
				string+='</table>';
				$('#cucu').append(string);
				
				$('#btnPluu2').click(function() {
					$('#btnPluu').click();
				});
				$('#btnCubs2').click(function() {
					$('#btnCubs').click();
				});
				
				//設定滾動條移動時浮動表頭與div的距離
				$('#cucu').scroll(function(){
					$('#cucu_float').css('top',$(this).scrollTop()+"px")
				});
				
				//---------------------------------------------------------------------------------------------------
				//移動下一格
				var SeekF= new Array();
				$('input:text,select').each(function() {
					if($(this).attr('disabled')!='disabled')
						SeekF.push($(this).attr('id'));
				});
				$('input:text,select').each(function() {
					$(this).bind('keydown', function(event) {
						if( event.which == 13 || event.which == 40) {
							$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1]).focus();
							$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1]).select();
						}
					});
				});
            }
            
            function q_gtPost(t_name) {
				switch (t_name) {
					case 'init':
						//載入bbs表頭
						var string = "<table id='cucs_table' style='width:1240px;word-break:break-all;table-layout:fixed;'>";
						string+='<tr id="cucs_header">';
						string+='<td id="cucs_chk" align="center" style="width:23px; color:black;">鎖定</td>';
						string+='<td id="cucs_cubno" align="center" style="width:20px; color:black;display:none;">鎖定人</td>'
						string+='<td id="cucs_noa" align="center" style="width:43px; color:black;">案號</td>'
						string+='<td id="cucs_noq" align="center" style="width:23px; color:black;">案序</td>'
						string+='<td id="cucs_odatea" title="預交日" align="center" style="width:80px; color:black;display:none;">預交日</td>';
						string+='<td id="cucs_ucolor" title="類別" align="center" style="width:120px; color:black;display:none;">類別</td>';
						string+='<td id="cucs_product" title="品名" align="center" style="width:70px; color:black;display:none;">品名</td>';
						string+='<td id="cucs_spec" title="材質" align="center" style="width:48px; color:black;">材質</td>';
						string+='<td id="cucs_size" title="號數" align="center" style="width:33px; color:black;">號數</td>';
						string+='<td id="cucs_lengthb" title="米數" align="center" style="width:33px; color:black;">米數</td>';
						string+='<td id="cucs_mount" title="訂單件數" align="center" style="width:33px; color:black;" class="co1">訂單<BR>件數</td>';
						string+='<td id="cucs_1mount" title="訂單支數" align="center" style="width:33px; color:black;" class="co1">訂單<BR>支數</td>';
						string+='<td id="cucs_weight" title="訂單重量" align="center" style="width:38px; color:black;" class="co1">訂單<BR>重量</td>';
						string+='<td id="cucs_emount" title="未完工件數" align="center" style="width:38px; color:black;display:none;" class="co2">未完工件數</td>';
						string+='<td id="cucs_ehmount" title="未完工支數" align="center" style="width:38px; color:black;display:none;" class="co2">未完工支數</td>';
						string+='<td id="cucs_eweight" title="未完工重量" align="center" style="width:38px; color:black;display:none;" class="co2">未完工重量</td>';
						string+='<td id="cucs_cubmount" title="已完工件數" align="center" style="width:43px; color:black;" class="co2">已完工<BR>件數</td>';
						string+='<td id="cucs_cubhmount" title="已完工支數" align="center" style="width:43px; color:black;" class="co2">已完工<BR>支數</td>';
						string+='<td id="cucs_cubweight" title="已完工重量" align="center" style="width:43px; color:black;" class="co2">已完工<BR>重量</td>';
						string+='<td id="cucs_xmount" title="件數" align="center" style="width:38px; color:black;" class="co3">件數</td>';
						string+='<td id="cucs_xcount" title="支數" align="center" style="width:38px; color:black;" class="co3">支數<BR><input id="btnAutoxcount" type="button" style="font-size: 10px; font-weight: bold; width: 35px;" value="代入"></td>';
						string+='<td id="cucs_xweight" title="重量" align="center" style="width:43px; color:black;" class="co3">重量<BR><a class="total_xweight" style="color: forestgreen;font-weight: bold;"></a></td>';
						string+='<td id="cucs_class" title="廠牌" align="center" style="width:43px; color:black;">廠牌</td>';
						string+='<td id="cucs_btime" title="顏色1" align="center" style="width:28px; color:black;">顏色<BR>1</td>';
						string+='<td id="cucs_etime" title="顏色2" align="center" style="width:28px; color:black;">顏色<BR>2</td>';
						string+='<td id="cucs_memo" title="備註(標籤)" align="center" style="width:83px; color:black;">備註(標籤)</td>';
						string+='<td id="cucs_4mount" title="彎" align="center" style="width:28px; color:black;" class="fhide1">彎</td>';
						string+='<td id="cucs_2mount" title="車" align="center" style="width:28px; color:black;" class="fhide2">車</td>';
						string+='<td id="cucs_img" title="圖形" align="center" style="width:103px; color:black;" class="imghide fhide1 fhide2">圖形</td>';
						string+='<td id="cucs_custno" title="客戶編號" align="center" style="width:73px; color:black;display:none;">客戶編號</td>';
						string+='<td id="cucs_cust" title="客戶/工地" align="center" style="width:73px; color:black;">客戶/工地</td>';
						string+='<td id="cucs_work" title="工令" align="center" style="width:78px; color:black;">工令</td>';
						string+='<td id="cucs_ordeno" title="訂單號碼" align="center" style="width:90px; color:black;display:none;">訂單號碼</td>';
						string+='<td id="cucs_no2" title="訂單序號" align="center" style="width:90px; color:black;display:none;">訂單序號</td>';
						//string+='<td id="cucs_mins" align="center" style="width:30px; color:black;">完工</td>';
						string+="<td id='cucs_mins' align='center' style='width:28px; color:black;'><input type='button' id='btnMins' style='font-size:12px;width: 30px;height: 45px;white-space: inherit;' value='已裁剪'/></td>";
						string+="<td id='cucs_waste' align='center' style='width:28px; color:black;' class='fhide1'><input type='button' id='btnWaste' style='font-size:12px;width: 30px;height: 45px;white-space: inherit;' value='已成型'/></td>";
						string+="<td id='cucs_hours' align='center' style='width:28px; color:black;' class='fhide2'><input type='button' id='btnHours' style='font-size:12px;width: 30px;height: 45px;white-space: inherit;' value='已車牙'/></td>";
						string+='<td id="cucs_width" title="待續接" align="center" style="display:none;width:22px; color:black;">待續接</td>';
						string+='<td id="cucs_dime" title="待成型" align="center" style="display:none;width:22px; color:black;">待成型</td>';
						string+='</tr>';
						string+='</table>';
						$('#cucs').html(string);
						
						//浮動表頭
						var string = "<div id='cucs_float' style='position:absolute;display:block;left:0px; top:0px;'>";
						string+="<table id='cucs_table2' style='width:1240px;border-bottom: none;table-layout:fixed;'>";
						string+='<tr id="cucs_header">';
						string+='<td id="cucs_chk" align="center" style="width:23px; color:black;">鎖定</td>';
						string+='<td id="cucs_cubno" align="center" style="width:20px; color:black;display:none;">鎖定人</td>'
						string+='<td id="cucs_noa" align="center" style="width:43px; color:black;">案號</td>'
						string+='<td id="cucs_noq" align="center" style="width:23px; color:black;">案序</td>'
						string+='<td id="cucs_odatea" title="預交日" align="center" style="width:80px; color:black;display:none;">預交日</td>';
						string+='<td id="cucs_ucolor" title="類別" align="center" style="width:120px; color:black;display:none;">類別</td>';
						string+='<td id="cucs_product" title="品名" align="center" style="width:70px; color:black;display:none;">品名</td>';
						string+='<td id="cucs_spec" title="材質" align="center" style="width:48px; color:black;">材質</td>';
						string+='<td id="cucs_size" title="號數" align="center" style="width:33px; color:black;">號數</td>';
						string+='<td id="cucs_lengthb" title="米數" align="center" style="width:33px; color:black;">米數</td>';
						string+='<td id="cucs_mount" title="訂單件數" align="center" style="width:33px; color:black;" class="co1" >訂單<BR>件數</td>';
						string+='<td id="cucs_1mount" title="訂單支數" align="center" style="width:33px; color:black;" class="co1">訂單<BR>支數</td>';
						string+='<td id="cucs_weight" title="訂單重量" align="center" style="width:38px; color:black;" class="co1">訂單<BR>重量</td>';
						string+='<td id="cucs_emount" title="未完工件數" align="center" style="width:38px; color:black;display:none;" class="co2">未完工件數</td>';
						string+='<td id="cucs_ehmount" title="未完工支數" align="center" style="width:38px; color:black;display:none;" class="co2">未完工支數</td>';
						string+='<td id="cucs_eweight" title="未完工重量" align="center" style="width:38px; color:black;display:none;" class="co2">未完工重量</td>';
						string+='<td id="cucs_cubmount" title="已完工件數" align="center" style="width:43px; color:black;" class="co2">已完工<BR>件數</td>';
						string+='<td id="cucs_cubhmount" title="已完工支數" align="center" style="width:43px; color:black;" class="co2">已完工<BR>支數</td>';
						string+='<td id="cucs_cubweight" title="已完工重量" align="center" style="width:43px; color:black;" class="co2">已完工<BR>重量</td>';
						string+='<td id="cucs_xmount" title="件數" align="center" style="width:38px; color:black;" class="co3">件數</td>';
						string+='<td id="cucs_xcount" title="支數" align="center" style="width:38px; color:black;" class="co3">支數<BR><input id="btnAutoxcount2" type="button" style="font-size: 10px; font-weight: bold; width: 35px;" value="代入"></td>';
						string+='<td id="cucs_xweight" title="重量" align="center" style="width:43px; color:black;" class="co3">重量<BR><a class="total_xweight" style="color: forestgreen;font-weight: bold;"></a></td>';
						string+='<td id="cucs_class" title="廠牌" align="center" style="width:43px; color:black;">廠牌</td>';
						string+='<td id="cucs_btime" title="顏色1" align="center" style="width:28px; color:black;">顏色<BR>1</td>';
						string+='<td id="cucs_etime" title="顏色2" align="center" style="width:28px; color:black;">顏色<BR>2</td>';
						string+='<td id="cucs_memo" title="備註(標籤)" align="center" style="width:83px; color:black;">備註(標籤)</td>';
						string+='<td id="cucs_4mount" title="彎" align="center" style="width:28px; color:black;" class="fhide1">彎</td>';
						string+='<td id="cucs_2mount" title="車" align="center" style="width:28px; color:black;" class="fhide2">車</td>';
						string+='<td id="cucs_img" title="圖形" align="center" style="width:103px; color:black;" class="imghide fhide1 fhide2">圖形</td>';
						string+='<td id="cucs_custno" title="客戶編號" align="center" style="width:73px; color:black;display:none;">客戶編號</td>';
						string+='<td id="cucs_cust" title="客戶/工地" align="center" style="width:73px; color:black;">客戶/工地</td>';
						string+='<td id="cucs_work" title="工令" align="center" style="width:78px; color:black;">工令</td>';
						string+='<td id="cucs_ordeno" title="訂單號碼" align="center" style="width:90px; color:black;display:none;">訂單號碼</td>';
						string+='<td id="cucs_no2" title="訂單序號" align="center" style="width:90px; color:black;display:none;">訂單序號</td>';
						//string+='<td id="cucs_mins" align="center" style="width:30px; color:black;">完工</td>';
						string+="<td id='cucs_mins' align='center' style='width:28px; color:black;'><input type='button' id='btnMins2' style='font-size:12px;width: 30px;height: 45px;white-space: inherit;' value='已裁剪'/></td>";
						string+="<td id='cucs_waste' align='center' style='width:28px; color:black;' class='fhide1'><input type='button' id='btnWaste2' style='font-size:12px;width: 30px;height: 45px;white-space: inherit;' value='已成型'/></td>";
						string+="<td id='cucs_hours' align='center' style='width:28px; color:black;' class='fhide2'><input type='button' id='btnHours2' style='font-size:12px;width: 30px;height: 45px;white-space: inherit;' value='已車牙'/></td>";
						string+='<td id="cucs_width" title="待續接" align="center" style="display:none;width:22px; color:black;">待續接</td>';
						string+='<td id="cucs_dime" title="待成型" align="center" style="display:none;width:22px; color:black;">待成型</td>';
						string+='</tr>';
						string+='</table>';
						$('#cucs_float').remove();
						$('#cucs').append(string);
						
						cucs_refresh();
						
						//設定滾動條移動時浮動表頭與div的距離
						$('#cucs').scroll(function(){
							$('#cucs_float').css('top',$(this).scrollTop()+"px")
						});
					
						var as = _q_appendData("view_cuc", "", true);
                        var comb_noa='@';
                        
                        for(var i=0;i<as.length;i++){
                        	if(comb_noa.indexOf(as[i].noa)==-1)
                        		comb_noa=comb_noa+","+as[i].noa+"@"+as[i].noa
                        }
                        $('#combCucno').text('');
                        q_cmbParse("combCucno", comb_noa);
                        
                        if(isclear){
                        	//清空該使用者的全部鎖定
							q_func('qtxt.query.unlockall', 'cuc_vu.txt,unlockall,'+r_userno.toUpperCase()+';'+r_name);
                        }
                        
                        //intervalupdate=setInterval("cucsupdata()",1000*60);
                        
                        $('#btnAutoxcount').click(function() {
                        	bbsrow=document.getElementById("cucs_table").rows.length-1;//重新取得最新的bbsrow
                        	
							for(var i=0;i<bbsrow;i++){
								if($('#cucs_chk'+i).prop('checked')){
									$('#textXcount_'+i).val(dec($('#cucs_ehmount'+i).text()));
									$('#textXcount_'+i).keyup();
									$('#textXcount_'+i).blur();
								}
							}
                        });
                        
                        $('#btnAutoxcount2').click(function() {
                        	$('#btnAutoxcount').click();
						});
						
						//完工
		                $('#btnMins').click(function() {
		                	t_mins_count=0;
		                	$('#cucs .cucs_mins').each(function(index) {
								if($(this).prop('checked')){
									t_mins_count++;
								}
							});
							
							if(t_mins_count>0){
								if(confirm("確認要完工?")){
									$('#cucs .cucs_mins').each(function(index) {
										if($(this).prop('checked')){
											var n=$(this).attr('id').replace('cucs_mins','')
											t_endanoa=$('#cucs_noa'+n).text();
											t_endanoq=$('#cucs_noq'+n).text();
											q_func('qtxt.query.enda_'+n, 'cuc_vu.txt,enda,'+r_accy+';'+$('#cucs_noa'+n).text()+';'+$('#cucs_noq'+n).text()+';'+r_userno.toUpperCase()+';'+r_name,r_accy,1);
											
											var as = _q_appendData("tmp0", "", true, true);
											//刪除核取的資料
											for(var j=0;j<chk_cucs.length;j++){
							                    if(t_endanoa==chk_cucs[j]['noa'] && t_endanoq==chk_cucs[j]['noq']){
							                    	chk_cucs.splice(j, 1);
							                    	t_endanoa='';
							                    	t_endanoq='';
					                        		break;
							                    }
											}
											t_mins_count--;
											//更新畫面
											if(t_mins_count<=0)
												cucsupdata();
										}
									});
								}else{
									t_mins_count=0;
								}
							}else{
								alert('無核取完工資料!');
							}
						});
						
						$('#btnMins2').click(function() {
                        	$('#btnMins').click();
						});
						
						//107/04/11
						//成型
		                $('#btnWaste').click(function() {
		                	t_waste_count=0;
		                	$('#cucs .cucs_waste').each(function(index) {
								if($(this).prop('checked')){
									t_waste_count++;
								}
							});
							
							if(t_waste_count>0){
								if(confirm("確認要成型?")){
									$('#cucs .cucs_waste').each(function(index) {
										if($(this).prop('checked')){
											var n=$(this).attr('id').replace('cucs_waste','')
											t_endanoa=$('#cucs_noa'+n).text();
											t_endanoq=$('#cucs_noq'+n).text();
											q_func('qtxt.query.wasteenda_'+n, 'cuc_vu.txt,wasteenda,'+r_accy+';'+$('#cucs_noa'+n).text()+';'+$('#cucs_noq'+n).text()+';'+r_userno.toUpperCase()+';'+r_name,r_accy,1);
											
											var as = _q_appendData("tmp0", "", true, true);
											//刪除核取的資料
											for(var j=0;j<chk_cucs.length;j++){
							                    if(t_endanoa==chk_cucs[j]['noa'] && t_endanoq==chk_cucs[j]['noq']){
							                    	chk_cucs.splice(j, 1);
							                    	t_endanoa='';
							                    	t_endanoq='';
					                        		break;
							                    }
											}
											t_waste_count--;
											//更新畫面
											if(t_waste_count<=0)
												cucsupdata();
										}
									});
								}else{
									t_waste_count=0;
								}
							}else{
								alert('無核取成型資料!');
							}
						});
						
						$('#btnWaste2').click(function() {
                        	$('#btnWaste').click();
						});
						
						//車牙
		                $('#btnHours').click(function() {
		                	t_hours_count=0;
		                	$('#cucs .cucs_hours').each(function(index) {
								if($(this).prop('checked')){
									t_hours_count++;
								}
							});
							
							if(t_hours_count>0){
								if(confirm("確認要車牙?")){
									$('#cucs .cucs_hours').each(function(index) {
										if($(this).prop('checked')){
											var n=$(this).attr('id').replace('cucs_hours','')
											t_endanoa=$('#cucs_noa'+n).text();
											t_endanoq=$('#cucs_noq'+n).text();
											q_func('qtxt.query.hoursenda_'+n, 'cuc_vu.txt,hoursenda,'+r_accy+';'+$('#cucs_noa'+n).text()+';'+$('#cucs_noq'+n).text()+';'+r_userno.toUpperCase()+';'+r_name,r_accy,1);
											
											var as = _q_appendData("tmp0", "", true, true);
											//刪除核取的資料
											for(var j=0;j<chk_cucs.length;j++){
							                    if(t_endanoa==chk_cucs[j]['noa'] && t_endanoq==chk_cucs[j]['noq']){
							                    	chk_cucs.splice(j, 1);
							                    	t_endanoa='';
							                    	t_endanoq='';
					                        		break;
							                    }
											}
											t_hours_count--;
											//更新畫面
											if(t_hours_count<=0)
												cucsupdata();
										}
									});
								}else{
									t_hours_count=0;
								}
							}else{
								alert('無核取車牙資料!');
							}
						});
						
						$('#btnHours2').click(function() {
                        	$('#btnHours').click();
						});
                        break;
					case 'importcucs':
						//現在表身資料
						var bbsrow=document.getElementById("cucs_table").rows.length-1;
						var as = _q_appendData("view_cuc", "", true);
						var imp_cucno=''; //匯入的cucno
						/*if(as[0]!=undefined && !isupdate){ //匯入資料就先鎖單
							imp_cucno=as[0].noa;
						}*/
						//變動核取資料
						for(var i =0 ;i<as.length;i++){
                    		var cubno=as[i]['cubno'];
							if(cubno.length>0){
								//判斷是否被鎖定或解除鎖定或鎖定時間超過15分
	                    		var lock_time=cubno.split('##')[3]!=undefined?cubno.split('##')[3]:'';
								var islock=false;
								if(lock_time.length>0){
									islock=true;
									var now_time = new Date();
									lock_time = new Date(lock_time);
									var diff = now_time - lock_time;
									if(diff>1000 * 60 * 15) //超過15分表示已解除鎖定
										islock=false;
								}
								
								if(islock && cubno.split('##')[0].toUpperCase()==r_userno.toUpperCase()){ //自己的鎖定資料
									var t_exists=false;
		                    		for(var j=0;j<chk_cucs.length;j++){
		                    			if(as[i]['noa']==chk_cucs[j]['noa'] && as[i]['noq']==chk_cucs[j]['noq']){
		                    				t_exists=true;
		                    			}
		                    		}
		                    		if(!t_exists){//當不存在時新增
		                    			chk_cucs.push({
												noa : as[i]['noa'],
												noq : as[i]['noq'],
												xmount : 0,
												xcount : 0,
												xweight : 0,
												ordeno:as[i]['ordeno'],
												no2:as[i]['no2']
										});
		                    		}
		                    	}else{//被他人鎖定資料 或鎖定時間超過15分
		                    		for(var j=0;j<chk_cucs.length;j++){
		                    			if(as[i]['noa']==chk_cucs[j]['noa'] && as[i]['noq']==chk_cucs[j]['noq']){
		                    				chk_cucs.splice(j, 1);
		                    				j--;
                        	 				break;
		                    			}
		                    		}
		                    	}
		                    }else{//無鎖定資料
		                    	for(var j=0;j<chk_cucs.length;j++){
		                    		if(as[i]['noa']==chk_cucs[j]['noa'] && as[i]['noq']==chk_cucs[j]['noq']){
		                    			chk_cucs.splice(j, 1);
		                    			j--;
                        	 			break;
		                    		}
		                    	}
		                    }
	                    }
	                    
						var table_noa='';
						if(bbsrow!=0){//表示目前有無資料 有要更新資料
							for(var j=0;j<bbsrow;j++){
								var bbsexists=false;
								for(var i =0 ;i<as.length;i++){
									if(as[i].noa==$('#cucs_noa'+j).text() && as[i].noq==$('#cucs_noq'+j).text()){
										bbsexists=true;
										//資料存在,更新表身資料
										$('#cucs_cubno'+j).text(as[i].cubno);
										$('#cucs_noa'+j).text(as[i].noa);
										$('#cucs_noq'+j).text(as[i].noq);
										$('#cucs_odatea'+j).text(as[i].odatea);
										$('#cucs_ucolor'+j).text(as[i].ucolor);
										$('#cucs_product'+j).text(as[i].product);
										$('#cucs_spec'+j).text(as[i].spec);
										$('#cucs_size'+j).text(as[i].size);
										$('#cucs_lengthb'+j).text(as[i].lengthb);
										$('#cucs_mount'+j).text(as[i].mount);
										$('#cucs_weight'+j).text(as[i].weight);
										$('#cucs_1mount'+j).text(as[i].mount1);
										$('#cucs_emount'+j).text(round(as[i].emount,3));
										$('#cucs_eweight'+j).text(round(as[i].eweight,3));
										$('#cucs_ehmount'+j).text(round(as[i].ehmount,3));
										$('#cucs_cubmount'+j).text(round(dec(as[i].cubmount),3));
										$('#cucs_cubweight'+j).text(round(dec(as[i].cubweight),3));
										$('#cucs_cubhmount'+j).text(round(dec(as[i].cubhmount),3));
										$('#lblCucs_class'+j).text(as[i].class);
										$('#lblCucs_btime'+j).text(as[i].btime);
										$('#lblCucs_etime'+j).text(as[i].etime);
										$('#cucs_memo'+j).text(as[i].memo);
										$('#cucs_4mount'+j).text(dec(as[i].mount4)>0?'V':'');
										$('#cucs_2mount'+j).text(dec(as[i].mount2)>0?dec(as[i].mount2):'');
										$('#Imgcucs_img'+j).attr('src',as[i].imgbarcode);
										$('#cucs_work'+j).text(as[i].size2);
										$('#cucs_custno'+j).text(as[i].acustno);
										$('#cucs_cust'+j).html('<a style="font-size: larger;">'+as[i].acust.substr(0,4)+'</a><BR><a>'+as[i].amech+'</a>');
										$('#cucs_ordeno'+j).text(as[i].ordeno);
										$('#cucs_no2'+j).text(as[i].no2);
										if(dec(as[i].waste)>0 || dec(as[i].mount4)==0){
											$('#cucs_waste'+j).css('display','none');
										}else{
											$('#cucs_waste'+j).css('display','unset');
										}
										$('#cucs_awaste'+j).text((dec(as[i].waste)>0 && dec(as[i].mount4)>0 ?'V':''));
										if(dec(as[i].hours)>0 || dec(as[i].mount2)==0){
											$('#cucs_hours'+j).css('display','none');
										}else{
											$('#cucs_hours'+j).css('display','unset');
										}
										$('#cucs_ahours'+j).text((dec(as[i].hours)>0 && dec(as[i].mount2)>0 ?'V':''));
										
										$('#cucs_width'+j).text((dec(as[i].mount2)>0 ?'V':''));//width
										$('#cucs_dime'+j).text((dec(as[i].dime)>0 ?'V':''));
										
										//移除已存在的資料
										as.splice(i, 1);
										i--;
										break;
									}
								}
								
								if(isupdate && !bbsexists){//更新資料 bbs 一定要存在 , 不存在表示已完工或資料被刪除
									//刪除bbs 資料
									$('#cucs_tr'+j).find('td').css('background', 'lavender');
									$('#cucs_tr'+j+' .co1').css('background-color', 'antiquewhite');
		                            $('#cucs_tr'+j+' .co2').css('background-color', 'lightpink');
		                            $('#cucs_tr'+j+' .co3').css('background-color', 'lightsalmon');
									$('#cucs_chk'+j).remove();
									$('#textXmount_'+j).remove();
									$('#textXcount_'+j).remove();
									$('#textXweight_'+j).remove();
									$('#cucs_lbla'+j).text();
									$('#cucs_cubno'+j).text('');
									$('#cucs_noa'+j).text('');
									$('#cucs_noq'+j).text('');
									$('#cucs_odatea'+j).text('');
									$('#cucs_ucolor'+j).text('');
									$('#cucs_product'+j).text('');
									$('#cucs_spec'+j).text('');
									$('#cucs_size'+j).text('');
									$('#cucs_lengthb'+j).text('');
									$('#cucs_mount'+j).text('');
									$('#cucs_weight'+j).text('');
									$('#cucs_1mount'+j).text('');
									$('#cucs_emount'+j).text('');
									$('#cucs_eweight'+j).text('');
									$('#cucs_ehmount'+j).text('');
									$('#cucs_cubmount'+j).text('');
									$('#cucs_cubweight'+j).text('');
									$('#cucs_cubhmount'+j).text('');
									$('#lblCucs_class'+j).text('');
									$('#combXclass_'+j).remove();
									$('#lblCucs_btime'+j).text('');
									$('#combXbtime_'+j).remove();
									$('#lblCucs_etime'+j).text('');
									$('#combXetime_'+j).remove();
									$('#cucs_memo'+j).text('');
									$('#cucs_4mount'+j).text('');
									$('#cucs_2mount'+j).text('');
									$('#Imgcucs_img'+j).attr('src','');
									$('#cucs_work'+j).text('');
									$('#cucs_custno'+j).text('');
									$('#cucs_cust'+j).html('');
									$('#cucs_ordeno'+j).text('');
									$('#cucs_no2'+j).text('');
									$('#cucs_mins'+j).remove();
									$('#cucs_waste'+j).remove();
									$('#cucs_awaste'+j).text('');
									$('#cucs_hours'+j).remove();
									$('#cucs_ahours'+j).text('');
									$('#cucs_width'+j).text('');//width
									$('#cucs_dime'+j).text('');
								}
							}
							table_noa=$('#cucs_noa'+(bbsrow-1)).text();
						}
						
						t_color = ['DarkBlue','DarkRed'];
						var string='';
						for(var i=0;i<as.length;i++){
							if(table_noa!='' && table_noa!=as[i].noa){ //不同案號 空依格
								string+='<tr id="cucs_tr'+(i+bbsrow)+'">';
								string+='<td style="text-align: center;"></td>';
								string+='<td id="cucs_cubno'+(i+bbsrow)+'" style="display:none;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_noa'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_noq'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_odatea'+(i+bbsrow)+'" style="display:none;font-size: 14px;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_ucolor'+(i+bbsrow)+'" style="display:none;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_product'+(i+bbsrow)+'" style="display:none;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_spec'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_size'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_lengthb'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_mount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co1"></td>';
								string+='<td id="cucs_1mount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co1"></td>';
								string+='<td id="cucs_weight'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co1"></td>';
								string+='<td id="cucs_emount'+(i+bbsrow)+'" style="display:none;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co2"></td>';
								string+='<td id="cucs_ehmount'+(i+bbsrow)+'" style="display:none;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co2"></td>';
								string+='<td id="cucs_eweight'+(i+bbsrow)+'" style="display:none;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co2"></td>';
								string+='<td id="cucs_cubmount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co2"></td>';
								string+='<td id="cucs_cubhmount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co2"></td>';
								string+='<td id="cucs_cubweight'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co2"></td>';
								string+='<td id="cucs_xmount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co3"></td>';
								string+='<td id="cucs_xcount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co3"></td>';
								string+='<td id="cucs_xweight'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co3"></td>';
								string+='<td id="cucs_class'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"><a id="lblCucs_class'+(i+bbsrow)+'"></a></td>';
								string+='<td id="cucs_btime'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"><a id="lblCucs_btime'+(i+bbsrow)+'"></a></td>';
								string+='<td id="cucs_etime'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"><a id="lblCucs_etime'+(i+bbsrow)+'"></a></td>';
								string+='<td id="cucs_memo'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_4mount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'" class="fhide1"></td>';
								string+='<td id="cucs_2mount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'" class="fhide2"></td>';
								string+='<td id="cucs_img'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'" class="imghide fhide1 fhide2"><img id="Imgcucs_img'+(i+bbsrow)+'" style="width:100px;"></td>';
								string+='<td id="cucs_custno'+(i+bbsrow)+'" style="display:none;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_cust'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_work'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_ordeno'+(i+bbsrow)+'" style="display:none;font-size: 12px;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_no2'+(i+bbsrow)+'" style="display:none;font-size: 12px;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td style="text-align: center;"></td>';
								string+='<td id="cucs_twaste'+(i+bbsrow)+'" style="text-align: center;" class="fhide1"><a id="cucs_awaste'+(i+bbsrow)+'"></a></td>';
								string+='<td id="cucs_thours'+(i+bbsrow)+'" style="text-align: center;" class="fhide2"><a id="cucs_ahours'+(i+bbsrow)+'"></a></td>';
								string+='<td id="cucs_width'+(i+bbsrow)+'" style="display:none;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='<td id="cucs_dime'+(i+bbsrow)+'" style="display:none;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"></td>';
								string+='</tr>';
								bbsrow++;
							}
							
							string+='<tr id="cucs_tr'+(i+bbsrow)+'">';
							string+='<td style="text-align: center;"><input id="cucs_chk'+(i+bbsrow)+'" class="cucs_chk" type="checkbox"/><a id="cucs_lbla'+(i+bbsrow)+'" ></a></td>';
							string+='<td id="cucs_cubno'+(i+bbsrow)+'" style="display:none;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].cubno+'</td>';
							string+='<td id="cucs_noa'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].noa+'</td>';
							string+='<td id="cucs_noq'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].noq+'</td>';
							string+='<td id="cucs_odatea'+(i+bbsrow)+'" style="display:none;font-size: 14px;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].odatea+'</td>';
							string+='<td id="cucs_ucolor'+(i+bbsrow)+'" style="display:none;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].ucolor+'</td>';
							string+='<td id="cucs_product'+(i+bbsrow)+'" style="display:none;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].product+'</td>';
							string+='<td id="cucs_spec'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].spec+'</td>';
							string+='<td id="cucs_size'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].size+'</td>';
							string+='<td id="cucs_lengthb'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].lengthb+'</td>';
							string+='<td id="cucs_mount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co1">'+as[i].mount+'</td>';
							string+='<td id="cucs_1mount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co1">'+as[i].mount1+'</td>';
							string+='<td id="cucs_weight'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co1">'+as[i].weight+'</td>';
							string+='<td id="cucs_emount'+(i+bbsrow)+'" style="display:none;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co2">'+round(as[i].emount,3)+'</td>';
							string+='<td id="cucs_ehmount'+(i+bbsrow)+'" style="display:none;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co2">'+round(as[i].ehmount,3)+'</td>';
							string+='<td id="cucs_eweight'+(i+bbsrow)+'" style="display:none;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co2">'+round(as[i].eweight,3)+'</td>';
							string+='<td id="cucs_cubmount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co2">'+round(dec(as[i].cubmount),3)+'</td>';
							string+='<td id="cucs_cubhmount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co2">'+round(dec(as[i].cubhmount),3)+'</td>';
							string+='<td id="cucs_cubweight'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co2">'+round(dec(as[i].cubweight),3)+'</td>';
							string+='<td id="cucs_xmount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co3"><input id="textXmount_'+(i+bbsrow)+'"  type="text" class="xmount txt c1 num" disabled="disabled" /></td>';
							string+='<td id="cucs_xcount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co3"><input id="textXcount_'+(i+bbsrow)+'"  type="text" class="xcount txt c1 num" disabled="disabled"/></td>';
							string+='<td id="cucs_xweight'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+';" class="co3"><input id="textXweight_'+(i+bbsrow)+'"  type="text" class="xweight txt c1 num" disabled="disabled"/></td>';
							string+='<td id="cucs_class'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"><a id="lblCucs_class'+(i+bbsrow)+'">'+as[i].class+'</a><select id="combXclass_'+(i+bbsrow)+'" class="txt comb" style="width: 20px;"> </select></td>';
							string+='<td id="cucs_btime'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"><a id="lblCucs_btime'+(i+bbsrow)+'">'+as[i].btime+'</a><select id="combXbtime_'+(i+bbsrow)+'" class="txt comb" style="width: 20px;"> </select></td>';
							string+='<td id="cucs_etime'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"><a id="lblCucs_etime'+(i+bbsrow)+'">'+as[i].etime+'</a><select id="combXetime_'+(i+bbsrow)+'" class="txt comb" style="width: 20px;"> </select></td>';
							string+='<td id="cucs_memo'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].memo+'</td>';
							string+='<td id="cucs_4mount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'" class="fhide1">'+(dec(as[i].mount4)>0?'V':'')+'</td>';
							string+='<td id="cucs_2mount'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'" class="fhide2">'+(dec(as[i].mount2)>0?dec(as[i].mount2):'')+'</td>';
							string+='<td id="cucs_img'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'" class="imghide fhide1 fhide2"><img id="Imgcucs_img'+(i+bbsrow)+'" src="'+as[i].imgbarcode+'" style="width:100px;"></td>';
							string+='<td id="cucs_custno'+(i+bbsrow)+'" style="display:none;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].acustno+'</td>';
							string+='<td id="cucs_cust'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'"><a style="font-size: larger;">'+as[i].acust.substr(0,4)+'</a><BR><a>'+as[i].amech+'</a></td>';
							string+='<td id="cucs_work'+(i+bbsrow)+'" style="text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].size2+'</td>';
							string+='<td id="cucs_ordeno'+(i+bbsrow)+'" style="display:none;font-size: 12px;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].ordeno+'</td>';
							string+='<td id="cucs_no2'+(i+bbsrow)+'" style="display:none;font-size: 12px;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+as[i].no2+'</td>';
							string+='<td style="text-align: center;"><input id="cucs_mins'+(i+bbsrow)+'" class="cucs_mins" type="checkbox"/></td>';
							string+='<td id="cucs_twaste'+(i+bbsrow)+'" style="text-align: center;" class="fhide1"><a id="cucs_awaste'+(i+bbsrow)+'">'+(dec(as[i].waste)>0 && dec(as[i].mount4)>0 ?'V':'')+'</a><input id="cucs_waste'+(i+bbsrow)+'" class="cucs_waste" type="checkbox" style="display:'+(dec(as[i].waste)>0 || dec(as[i].mount4)==0 ?'none':'unset')+';"/></td>';
							string+='<td id="cucs_thours'+(i+bbsrow)+'" style="text-align: center;" class="fhide2"><a id="cucs_ahours'+(i+bbsrow)+'">'+(dec(as[i].hours)>0 && dec(as[i].mount2)>0 ?'V':'')+'</a><input id="cucs_hours'+(i+bbsrow)+'" class="cucs_hours" type="checkbox" style="display:'+(dec(as[i].hours)>0 || dec(as[i].mount2)==0?'none':'unset')+';"/></td>';
							string+='<td id="cucs_width'+(i+bbsrow)+'" style="display:none;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+(dec(as[i].mount2)>0 ?'V':'')+'</td>';//width
							string+='<td id="cucs_dime'+(i+bbsrow)+'" style="display:none;text-align: center;color:'+t_color[(i+bbsrow)%t_color.length]+'">'+(dec(as[i].dime)>0 ?'V':'')+'</td>';
							string+='</tr>';
							
							table_noa=as[i].noa;
						}
						
						$('#cucs_table').append(string);
						cucs_refresh();
						tot_xweight_refresh();
						if(chk_cucs.length>0){
							//clearInterval(intervalupdate);
							intervalupdate = setInterval(";");
							for (var i = 0 ; i < intervalupdate ; i++) {
							    clearInterval(i); 
							}
							setInterval("dialog_show()",1000*5);
						}
						
						isupdate=false;
						
						var t_coloritem=",棕,紅,白,黃,綠,灰,藍";
						$('#cucs_table .comb').unbind("change");
                    	$('#cucs_table .comb').each(function(index) {
                    		$(this).text('');
                    		var id=$(this).attr('id').split('_')[0];
                    		var n=$(this).attr('id').split('_')[1];
                    		if(id=='combXclass'){
	                    		q_cmbParse("combXclass_"+n, t_class);
	                    		$('#combXclass_'+n).val($('#lblCucs_class'+n).text());
	                    		
	                    		$(this).change(function() {
	                    			//1113 更新廠牌到cucs
	                    			q_func('qtxt.query.cucs_class_update', 'cuc_vu.txt,updateclass,'+r_accy+';'+$('#cucs_noa'+n).text()+';'+$('#cucs_noq'+n).text()+';'+r_userno.toUpperCase()+';'+r_name+';'+$(this).val());
	                    			$('#lblCucs_class'+n).text($(this).val());
								});
							}
							if(id=='combXbtime'){
	                    		q_cmbParse("combXbtime_"+n, t_coloritem);
	                    		$('#combXbtime_'+n).val($('#lblCucs_btime'+n).text());
	                    		
	                    		$(this).change(function() {
	                    			//1113 更新顏色1到cucs
	                    			q_func('qtxt.query.cucs_btime_update', 'cuc_vu.txt,updatebtime,'+r_accy+';'+$('#cucs_noa'+n).text()+';'+$('#cucs_noq'+n).text()+';'+r_userno.toUpperCase()+';'+r_name+';'+$(this).val());
	                    			$('#lblCucs_btime'+n).text($(this).val());
								});
							}
							if(id=='combXetime'){
	                    		q_cmbParse("combXetime_"+n, t_coloritem);
	                    		$('#combXetime_'+n).val($('#lblCucs_etime'+n).text());
	                    		
	                    		$(this).change(function() {
	                    			//1113 更新顏色2到cucs
	                    			q_func('qtxt.query.cucs_etime_update', 'cuc_vu.txt,updateetime,'+r_accy+';'+$('#cucs_noa'+n).text()+';'+$('#cucs_noq'+n).text()+';'+r_userno.toUpperCase()+';'+r_name+';'+$(this).val());
	                    			$('#lblCucs_etime'+n).text($(this).val());
								});
							}
                    	})
						
						//事件更新
						$('#cucs .cucs_chk').unbind('click');
						$('#cucs .cucs_chk').click(function(e) {
							var n=$(this).attr('id').replace('cucs_chk','')
							if($(this).prop('checked')){
								var t_err = q_chkEmpField([['combMechno', '人員組別']]);
				                if (t_err.length > 0 || chk_cucs.length>=8) {
				                	if(t_err.length>0)
				                    	alert(t_err);
				                    else 
				                    	alert('加工項目超過8筆!!');
				                    $(this).prop("checked",false).parent().parent().find('td').css('background', 'lavender');
				                    $('#cucs_tr'+n+' .co1').css('background-color', 'antiquewhite');
		                            $('#cucs_tr'+n+' .co2').css('background-color', 'lightpink');
		                            $('#cucs_tr'+n+' .co3').css('background-color', 'lightsalmon');
		                            
		                            var cucsno=$('#cucs_noa' + n).text();
									var eweight=dec($('#cucs_eweight' + n).text());
									var erate=q_div(dec($('#cucs_eweight' + n).text()),dec($('#cucs_weight' + n).text()));
									//1126 完工達到97% 呈現灰色
									if(cucsno!='' && erate<=0.03){
										$('#cucs_tr'+n).find('td').css('background', 'lightgrey');
									}
				                    return;
				                }
							}
							//Lock();
							var t_where="where=^^  1=1 and a.noa='"+$('#cucs_noa'+n).text()+"' and b.noq='"+$('#cucs_noq'+n).text()+"' and isnull(a.gen,0)=0 and isnull(b.mins,0)=0 ^^";
							var t_where1 = "where[1]=^^ cb.productno2=b.noa and cb.product2=b.noq and case when isnull(ca.itype,'')='' then '1' else ca.itype end ='1' ^^";
							//判斷是否能被鎖定或解除
							if($(this).prop('checked')){
								q_gt('cucs_vu', t_where+t_where1, 0, 0, 0,'getcanlock_'+n, r_accy);
							}else{
								q_gt('cucs_vu', t_where+t_where1, 0, 0, 0,'getcanunlock_'+n, r_accy);
							}
						});
	                    
	                    $('#cucs .num').unbind('blur');
	                    $('#cucs .num').unbind('keyup');
	                    $('#cucs .num').unbind('focus');
	                    $('#cucs .num').each(function() {
	                    	$(this).blur(function() {
	                    		var objnamea=$(this).attr('id').split('_')[0];
		                        var n=$(this).attr('id').split('_')[1];
		                        //修改暫存資料
		                        for(var i =0 ;i<chk_cucs.length;i++){
									if(chk_cucs[i].noa==$('#cucs_noa'+n).text() && chk_cucs[i].noq==$('#cucs_noq'+n).text()){
										if(objnamea=='textXmount')
											chk_cucs[i].xmount=$('#'+objnamea+'_'+n).val();
										if(objnamea=='textXcount')
											chk_cucs[i].xcount=$('#'+objnamea+'_'+n).val();
										if(objnamea=='textXweight')
											chk_cucs[i].xweight=$('#'+objnamea+'_'+n).val();
		                        	 	break;
									}
								}
							});
							
							$(this).focus(function() {
	                    		var objnamea=$(this).attr('id').split('_')[0];
		                        var n=$(this).attr('id').split('_')[1];
		                        if(objnamea=='textXcount')
		                        	$(this).select();
							});
							
							$(this).keyup(function(e) {
								if(e.which>=37 && e.which<=40){return;}
								var tmp=$(this).val();
								tmp=tmp.match(/\d{1,}\.{0,1}\d{0,}/);
								$(this).val(tmp);
								
								var objnamea=$(this).attr('id').split('_')[0];
		                        var n=$(this).attr('id').split('_')[1];
								//1104填入支數時，重量可以運算出理論重量
		                        if(objnamea=='textXcount'){
		                        	var t_1mount=dec($('#cucs_1mount'+n).text());
		                        	var t_xcount=dec($(this).val());
		                        	if(t_1mount>0){
		                        		var t_weight=dec($('#cucs_weight'+n).text());
		                        		$('#textXweight_'+n).val(round(q_mul(q_div(t_weight,t_1mount),t_xcount),0));
		                        		$('#textXweight_'+n).blur();
		                        	}
		                        }
		                        
		                        tot_xweight_refresh();
							});
						});
						
						//完工 //1130 改成多選完工
						/*$('#cucs .cucs_mins').unbind('click');
						$('#cucs .cucs_mins').click(function(e) {
							if($(this).prop('checked')){
								if(confirm("確認要完工?")){
									var n=$(this).attr('id').replace('cucs_mins','')
									t_endanoa=$('#cucs_noa'+n).text();
									t_endanoq=$('#cucs_noq'+n).text();
									q_func('qtxt.query.enda', 'cuc_vu.txt,enda,'+r_accy+';'+$('#cucs_noa'+n).text()+';'+$('#cucs_noq'+n).text()+';'+r_userno+';'+r_name);
								}else{
									$(this).prop('checked',false);
								}
							}							
						});*/
						
						//第一次匯入就先核取
						bbsrow=document.getElementById("cucs_table").rows.length-1;//重新取得最新的bbsrow
						if(imp_cucno.length>0){
							for(var i=0;i<bbsrow;i++){
								if($('#cucs_noa'+i).text()==imp_cucno && !$('#cucs_chk'+i).prop('checked')
								&& !$('#cucs_chk'+i).prop('disabled')){ //沒有被核取過的資料 且目前沒被鎖定過
									$('#cucs_chk'+i).prop('checked',true).parent().parent().find('td').css('background', 'darkturquoise');
									var t_where="where=^^ 1=1 and a.noa='"+$('#cucs_noa'+i).text()+"' and b.noq='"+$('#cucs_noq'+i).text()+"' and isnull(a.gen,0)=0 and isnull(b.mins,0)=0 ^^";
									var t_where1 = "where[1]=^^ cb.productno2=b.noa and cb.product2=b.noq and case when isnull(ca.itype,'')='' then '1' else ca.itype end ='1' ^^";
									q_gt('cucs_vu', t_where+t_where1, 0, 0, 0,'getcanlock_'+i, r_accy);
									//$('#cucs_chk'+i).click();
									//$('#cucs_chk'+i).prop('checked',true).parent().parent().find('td').css('background', 'darkturquoise');
								}
							}
							cucs_refresh();
						}
						imp_cucno='';
						
						//移動下一格
						var SeekF= new Array();
						$('input:text,select').each(function() {
							if($(this).attr('disabled')!='disabled')
								SeekF.push($(this).attr('id'));
						});
						$('input:text,select').each(function() {
							$(this).bind('keydown', function(event) {
								if( event.which == 13 || event.which == 40) {
									$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1]).focus();
									$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1]).select();
								}
							});
						});
                        Unlock();
                    	break;
                    case 'tocub':
                    	var as = _q_appendData("view_cuc", "", true);
                    	if (as[0] != undefined){
                    		var t_noa='';
                    		var t_noq='';
                    		var t_xmount='';
                    		var t_xcount='';
                    		var t_xweight='';
                    		var t_err='';
                    		for (var i=0;i<chk_cucs.length;i++){
                    			var t_exists=false;
                    			for (var j=0;j<as.length;j++){
                    				if(chk_cucs[i]['noa']==as[j]['noa'] && chk_cucs[i]['noq']==as[j]['noq']){//表示加工排程單存在
                    					if(as[j]['cubno'].split('##')[0].toUpperCase()!=r_userno.toUpperCase()){
                    						t_err+=chk_cucs[i]['ordeno']+'-'+chk_cucs[i]['no2']+"鎖定人員非自己本人!!";
                    					}
                    					/*if(dec(as[j].emount)<dec(chk_cucs[i]['xmount'])){
                    						t_err+=chk_cucs[i]['ordeno']+'-'+chk_cucs[i]['no2']+"加工數量大於未完工數!!";
                    					}
                    					if(dec(as[j].eweight)<dec(chk_cucs[i]['xweight'])){
                    						t_err+=chk_cucs[i]['ordeno']+'-'+chk_cucs[i]['no2']+"加工重量大於未完工重!!";
                    					}*/
                    					t_exists=true;
                    					break;
                    				}
                    			}
                    			if(t_err.length>0){
                    				break;
                    			}else if(!t_exists){
                    				t_err=chk_cucs[i]['ordeno']+'-'+chk_cucs[i]['no2']+"加工排程單不存在!!";
                    				break;
                    			}else{//表示資料正常
                    				if(dec(chk_cucs[i]['xmount'])>0 || dec(chk_cucs[i]['xweight'])>0){
	                    				t_noa=t_noa+chk_cucs[i]['noa']+'^';
			                    		t_noq=t_noq+chk_cucs[i]['noq']+'^';
			                    		t_xmount=t_xmount+dec(chk_cucs[i]['xmount'])+'^';
			                    		t_xcount=t_xcount+dec(chk_cucs[i]['xcount'])+'^';
			                    		t_xweight=t_xweight+dec(chk_cucs[i]['xweight'])+'^';
		                    		}
                    			}
                    		}
                    		if(t_err.length>0){
                    			alert(t_err);
                    		}else if(t_noa.length==0 || t_noq.length==0){
                    			alert('排程加工資料無設定數量或重量。');
                    		}else{
                    			//表身資料更新
                    			//更新庫存
				                //10/27領料入庫要獨立分開 故不更新庫存
				                stkupdate=0
				                var bbtrow=document.getElementById("cuct_table").rows.length-1;
				                /*for(var j=0;j<bbtrow;j++){
					                if(dec($('#textGmount_'+j).val())!=0 || dec($('#textGweight_'+j).val())!=0){
										var x_product=$('#textProduct_'+j).val();
										var x_ucolor=$('#textUcolor_'+j).val();
										var x_spec=$('#textSpec_'+j).val();
										var x_size=$('#textSize_'+j).val();
										var x_lengthb=$('#textLengthb_'+j).val();
										var x_class=$('#textClass_'+j).val();
										var x_edate=$('#textDatea').val();
										if((x_product.length>0 || x_ucolor.length>0 || x_spec.length>0 || x_size.length>0 || x_lengthb.length>0 || x_class.length>0) && x_edate.length>0){
											x_product=emp($('#textProduct_'+j).val())?'#non':$('#textProduct_'+j).val();
											x_ucolor=emp($('#textUcolor_'+j).val())?'#non':$('#textUcolor_'+j).val();
											x_spec=emp($('#textSpec_'+j).val())?'#non':$('#textSpec_'+j).val();
											x_size=emp($('#textSize_'+j).val())?'#non':$('#textSize_'+j).val();
											x_lengthb=emp($('#textLengthb_'+j).val())?'#non':$('#textLengthb_'+j).val();
											x_class=emp($('#textClass_'+j).val())?'#non':$('#textClass_'+j).val();
											x_edate=emp($('#textDatea').val())?q_date():$('#textDatea').val();
											q_func('qtxt.query.cucsstkcuct_'+j, 'cuc_vu.txt,stk_vu,'+x_product+';'+x_ucolor+';'+x_spec+';'+x_size+';'+x_lengthb+';'+x_class+';'+x_edate+';1');
											stkupdate++;
										}
									}
								}*/
								//無庫存更新
								if(stkupdate==0){
									var t_datea=emp($('#textDatea').val())?'#non':$('#textDatea').val();
	                    			var t_mechno=emp($('#combMechno').val())?'#non':$('#combMechno').val();
	                    			var t_memo=emp($('#textMemo').val())?'#non':$('#textMemo').val();
	                    			
	                    			//表身資料
	                    			var ts_bbt='';
	                    			/*var bbtrow=document.getElementById("cuct_table").rows.length-1;
	                    			for(var j=0;j<bbtrow;j++){
	                    				var ts_product=$('#textProduct_'+j).val();
		                    			var ts_ucolor=$('#textUcolor_'+j).val();
										var ts_spec=$('#textSpec_'+j).val();
										var ts_size=$('#textSize_'+j).val();
										var ts_lengthb=$('#textLengthb_'+j).val();
										var ts_class=$('#textClass_'+j).val();
										var ts_gmount=$('#textGmount_'+j).val();
										var ts_gweight=$('#textGweight_'+j).val();
										var ts_avgweight=$('#textAvgweight_'+j).val();
										var ts_memo=$('#textMemo_'+j).val();
										
										//if(!emp(ts_product) || !emp(ts_ucolor) || !emp(ts_spec) || !emp(ts_size) || 
										//	!emp(ts_lengthb) || !emp(ts_class) || !emp(ts_gmount) || !emp(ts_gweight) || !emp(ts_memo)){
										if(dec(ts_gweight)>0 && dec(ts_avgweight)>0){
											ts_bbt=ts_bbt
											+ts_product+"^@^"
											+ts_ucolor+"^@^"
											+ts_spec+"^@^"
											+ts_size+"^@^"
											+dec(ts_lengthb)+"^@^"
											+ts_class+"^@^"
											+dec(ts_gmount)+"^@^"
											+dec(ts_gweight)+"^@^"
											+ts_memo+"^@^"
											+"^#^";
	                    				}
	                    			}*/
	                    			
	                    			//107/06/22 自動領續接器
	                    			var t_sas=[];
	                    			var bbsrow=document.getElementById("cucs_table").rows.length-1;
	                    			for (var i=0;i<chk_cucs.length;i++){
	                    				var texistsas=false;
	                    				if(dec(chk_cucs[i]['xmount'])>0 || dec(chk_cucs[i]['xweight'])>0){
	                    					if(dec(chk_cucs[i]['xcount'])>0){ //支數打才能計算需要的續接器個數
		                    					for (var j=0;j<bbsrow;j++){
		                    						if(chk_cucs[i]['noa']==$('#cucs_noa'+j).text() && chk_cucs[i]['noq']==$('#cucs_noq'+j).text()&& $('#cucs_scolor'+j).text().length>0){
		                    							if($('#cucs_paraf'+j).text().length>0){
		                    								texistsas=false;
			                    							for (var k=0;k<t_sas.length;k++){
			                    								if(t_sas[k].product==$('#cucs_scolor'+j).text() && t_sas[k].size==$('#cucs_paraf'+j).text()){
			                    									t_sas[k].gmount=q_add(t_sas[k].gmount,dec(chk_cucs[i]['xcount']));
			                    									texistsas=true;
			                    									break;
			                    								}
			                    							}
			                    							if(!texistsas){
				                    							t_sas.push({
				                    								'product':$('#cucs_scolor'+j).text(),
				                    								'ucolor':'',
				                    								'spec':'',
				                    								'size':$('#cucs_paraf'+j).text(),
				                    								'lengthb':'',
				                    								'class':'',
				                    								'gmount':dec(chk_cucs[i]['xcount']),
				                    								'gweight':0,
				                    								'memo':'',
				                    							});
			                    							}
		                    							}
		                    							if($('#cucs_parag'+j).text().length>0){
		                    								texistsas=false;
			                    							for (var k=0;k<t_sas.length;k++){
			                    								if(t_sas[k].product==$('#cucs_scolor'+j).text() && t_sas[k].size==$('#cucs_parag'+j).text()){
			                    									t_sas[k].gmount=q_add(t_sas[k].gmount,dec(chk_cucs[i]['xcount']));
			                    									texistsas=true;
			                    									break;
			                    								}
			                    							}
			                    							if(!texistsas){
				                    							t_sas.push({
				                    								'product':$('#cucs_scolor'+j).text(),
				                    								'ucolor':'',
				                    								'spec':'',
				                    								'size':$('#cucs_parag'+j).text(),
				                    								'lengthb':'',
				                    								'class':'',
				                    								'gmount':dec(chk_cucs[i]['xcount']),
				                    								'gweight':0,
				                    								'memo':'',
				                    							});
			                    							}
		                    							}
		                    							break;
		                    						}
		                    					}
	                    					}
	                    				}
	                    			}
	                    			
	                    			if(t_sas.length>0){
	                    				for (var k=0;k<t_sas.length;k++){
	                    					ts_bbt=ts_bbt
											+t_sas[k].product+"^@^"
											+t_sas[k].ucolor+"^@^"
											+t_sas[k].spec+"^@^"
											+t_sas[k].size+"^@^"
											+t_sas[k].lengthb+"^@^"
											+t_sas[k].class+"^@^"
											+t_sas[k].gmount+"^@^"
											+t_sas[k].gweight+"^@^"
											+t_sas[k].memo+"^@^"
											+"^#^";
	                    				}
	                    			}
	                    			
	                    			if(ts_bbt.length==0){
	                    				ts_bbt='#non'
	                    			}
	                    			q_func('qtxt.query.cucstocub', 'cuc_vu.txt,cucstocub,'
	                    			+r_accy+';'+t_datea+';'+t_mechno+';'+t_memo+';'
	                    			+r_userno.toUpperCase()+';'+r_name+';'+t_noa+';'+t_noq+';'+t_xmount+';'+t_xcount+';'+t_xweight+';'+ts_bbt+';1');
	                    			//取消刷新
	                    			//clearInterval(intervalupdate);
								}
							}
                    	}else{
                            alert('無排程單!!');
                    	}
                    	Unlock();
                    	break;
                    case 'ucc':
                    	var as = _q_appendData("ucc", "", true);
						t_ucc='@';
						for ( i = 0; i < as.length; i++) {
							t_ucc+=","+as[i].product;
						}
						q_cmbParse("combProduct", t_ucc);
						
						$('#combProduct').val('鋼筋');
                    	
                    	break;
					case 'spec':
						var as = _q_appendData("spec", "", true);
						t_spec='@';
						for ( i = 0; i < as.length; i++) {
							t_spec+=","+as[i].noa;
						}
						q_cmbParse("combSpec", t_spec);
						
						$('#cuct_table .comb').each(function(index) {
							//帶入選項值
							var n=$(this).attr('id').split('_')[1];
							var objname=$(this).attr('id').split('_')[0];
							if(objname=='combSpec'){
								$(this).text(''); //清空資料
								q_cmbParse("combSpec_"+n, t_spec);
							}
						});
						$('#cucu_table .comb').each(function(index) {
							//帶入選項值
							var n=$(this).attr('id').split('__')[1];
							var objname=$(this).attr('id').split('__')[0];
							if(objname=='combSpec'){
								$(this).text(''); //清空資料
								q_cmbParse("combSpec__"+n, t_spec);
							}
						});
						break;
					case 'color':
						var as = _q_appendData("color", "", true);
						t_ucolor='@';
						for ( i = 0; i < as.length; i++) {
							t_ucolor+=","+as[i].color;
						}
						$('#cuct_table .comb').each(function(index) {
							//帶入選項值
							var n=$(this).attr('id').split('_')[1];
							var objname=$(this).attr('id').split('_')[0];
							if(objname=='combUcolor'){
								$(this).text(''); //清空資料
								q_cmbParse("combUcolor_"+n, ',板料');
							}
						});
						$('#cucu_table .comb').each(function(index) {
							//帶入選項值
							var n=$(this).attr('id').split('__')[1];
							var objname=$(this).attr('id').split('__')[0];
							if(objname=='combUcolor'){
								$(this).text(''); //清空資料
								q_cmbParse("combUcolor__"+n, ',定尺,板料,亂尺');
							}
						});
						break;
					case 'class':
						var as = _q_appendData("class", "", true);
						t_class='@';
						for ( i = 0; i < as.length; i++) {
							t_class+=","+as[i].noa;
						}
						$('#cuct_table .comb').each(function(index) {
							//帶入選項值
							var n=$(this).attr('id').split('_')[1];
							var objname=$(this).attr('id').split('_')[0];
							if(objname=='combClass'){
								$(this).text(''); //清空資料
								q_cmbParse("combClass_"+n, t_class);
							}
						});
						$('#cucu_table .comb').each(function(index) {
							//帶入選項值
							var n=$(this).attr('id').split('__')[1];
							var objname=$(this).attr('id').split('__')[0];
							if(objname=='combClass'){
								$(this).text(''); //清空資料
								q_cmbParse("combClass__"+n, t_class);
							}
						});
						break;
					case 'mech':
						var as = _q_appendData("mech", "", true);
						t_mech='@';
						for ( i = 0; i < as.length; i++) {
							t_mech+=","+as[i].noa+"@"+as[i].mech;
						}
						$('#combMechno').text();
						q_cmbParse("combMechno", t_mech);
						break;
					case 'nouno_getuno':
						var as = _q_appendData("view_cubs", "", true);
						if (as[0] != undefined) {
							var t_nouno=$.trim($('#textNouno').val()).split(',');
							var tt_nouno='';
							var t_mount=0,t_weight=0;
							for (var i=0;i<t_nouno.length;i++){
								var t_exists=false;
								for (var j=0;j<as.length;j++){
									if(as[j].uno==t_nouno[i]){
										t_exists=true;
										t_mount=q_add(t_mount,dec(as[j].mount));
										t_weight=q_add(t_mount,dec(as[j].weight));
									}
								}
								if(!t_exists){
									alert("批號【"+t_nouno[i]+"】不存在或已領料!!")
									tt_nouno='';
									break;
								}else if(t_mount<=0 && t_mount<=0){
									alert("批號【"+t_nouno[i]+"】已領料!!")
									tt_nouno='';
									break;
								}else{
									tt_nouno=tt_nouno+t_nouno[i]+"#";
								}
							}
							var t_mechno=emp($('#combMechno').val())?'#non':$('#combMechno').val();
							
							if(tt_nouno.length>0)
								q_func('qtxt.query.cubnouno', 'cub.txt,cubnouno_vu,' + encodeURI(r_accy) + ';' + encodeURI(tt_nouno)+ ';' + encodeURI(t_mechno)+ ';' + encodeURI(r_userno.toUpperCase())+ ';' + encodeURI(r_name));
						}else{
							alert("批號不存在!!");
						}
						break;
					case q_name:
						if (q_cur == 4)
							q_Seek_gtPost();
						break;
				}
				if(t_name.indexOf("getcanlock_")>-1){
					var n=t_name.split('_')[1];
					var as = _q_appendData("view_cuc", "", true);
					if (as[0] != undefined){//是否有資料
						var cubno=as[0].cubno;
						var islock=false;
						if(cubno!=''){
							var lock_time=cubno.split('##')[3]!=undefined?cubno.split('##')[3]:'';
							if(lock_time.length>0){
								islock=true;
								var now_time = new Date();
								lock_time = new Date(lock_time);
								var diff = now_time - lock_time;
								if(diff>1000 * 60 * 15) //超過15分表示已解除鎖定
									islock=false;
							}
						}
						if(islock && cubno!='' && cubno.split('##')[0].toUpperCase() != r_userno.toUpperCase()){//其他人被鎖定
							var mechno=cubno.split('##')[2]!=undefined?cubno.split('##')[2]:'';
							var tt_mech=t_mech.split(',');
							for(var k=0;k<tt_mech.length;k++){
								if(tt_mech[k].split('@')[0]==mechno){
									mechno=tt_mech[k].split('@')[1];
									break;
								}
							}
							alert("該筆排程已被"+mechno+"鎖定!!");
							$('#cucs_lbla'+n).text(mechno);
							$('#cucs_cubno'+n).text(cubno);
							$('#cucs_chk'+n).prop("checked",false).attr('disabled', 'disabled').parent().parent().find('td').css('background', 'lavender');
							$('#cucs_tr'+n+' .co1').css('background-color', 'antiquewhite');
                            $('#cucs_tr'+n+' .co2').css('background-color', 'lightpink');
                            $('#cucs_tr'+n+' .co3').css('background-color', 'lightsalmon');	
                        	//檢查是否有暫存 並刪除暫存資料
                        	 for(var i =0 ;i<chk_cucs.length;i++){
                        	 	if(chk_cucs[i].noa==$('#cucs_noa'+n).text() && chk_cucs[i].noq==$('#cucs_noq'+n).text()){
                        	 		chk_cucs.splice(i, 1);
                        	 		break;
                        	 	}
                        	 }
                        	//關閉欄位修改
                        	$('#textXmount_'+n).val('').attr('disabled', 'disabled');
                            $('#textXcount_'+n).val('').attr('disabled', 'disabled');
                            $('#textXweight_'+n).val('').attr('disabled', 'disabled');
                            $('#combXclass_'+n).val('').attr('disabled', 'disabled');
                            $('#combXbtime_'+n).val('').attr('disabled', 'disabled');
                            $('#combXetime_'+n).val('').attr('disabled', 'disabled');
						}else{//未鎖定資料
							$('#cucs_chk'+n).prop("checked",true).parent().parent().find('td').css('background', 'darkturquoise');
							//鎖定資料
                        	q_func('qtxt.query.lock', 'cuc_vu.txt,lock,'+r_accy+';'+$('#cucs_noa'+n).text()+';'+$('#cucs_noq'+n).text()+';'+r_userno.toUpperCase()+';'+r_name+';'+$('#combMechno').val());
                        	var t_datea=new Date();
                        	t_datea=t_datea.getFullYear()+'-'+(t_datea.getMonth()+1>9?t_datea.getMonth():'0'+(t_datea.getMonth()+1))
                        	+'-'+(t_datea.getDate()+1>9?t_datea.getDate():'0'+t_datea.getDate())
                        	+' '+(t_datea.getHours()+1>9?t_datea.getHours():'0'+t_datea.getHours())
                        	+':'+(t_datea.getMinutes()+1>9?t_datea.getMinutes():'0'+t_datea.getMinutes())
                        	+':'+(t_datea.getSeconds()+1>9?t_datea.getSeconds():'0'+t_datea.getSeconds())
                        	$('#cucs_cubno'+n).text(r_userno.toUpperCase()+"##"+r_name+"##"+$('#combMechno').val()+"##"+t_datea);
                        	//暫存資料
                        	chk_cucs.push({
								noa : $('#cucs_noa'+n).text(),
								noq : $('#cucs_noq'+n).text(),
								xmount : $('#textXmount_'+n).val(),
								xcount : $('#textXcount_'+n).val(),
								xweight : $('#textXweight_'+n).val(),
								ordeno:$('#cucs_ordeno'+n).text(),
								no2:$('#cucs_no2'+n).text()
							});
                        	//開放欄位修改
                        	$('#textXmount_'+n).removeAttr('disabled');
							$('#textXcount_'+n).removeAttr('disabled');
							$('#textXweight_'+n).removeAttr('disabled');
							$('#textXmount_'+n).val(1).blur();
							$('#combXclass_'+n).removeAttr('disabled');
							$('#combXbtime_'+n).removeAttr('disabled');
							$('#combXetime_'+n).removeAttr('disabled');
						}
					}else{
						$('#cucs_chk'+n).prop("checked",false).attr('disabled', 'disabled').parent().parent().find('td').css('background', 'lavender');
						$('#cucs_tr'+n+' .co1').css('background-color', 'antiquewhite');
						$('#cucs_tr'+n+' .co2').css('background-color', 'lightpink');
						$('#cucs_tr'+n+' .co3').css('background-color', 'lightsalmon');	
						alert('該筆排程已完工!!');
					}
					//Unlock();
					tot_xweight_refresh();
					if(chk_cucs.length==0){
						intervalupdate = setInterval(";");
						for (var i = 0 ; i < intervalupdate ; i++) {
						    clearInterval(i); 
						}
						intervalupdate=setInterval("cucsupdata()",1000*60);
						setInterval("dialog_show()",1000*5);
					}else{
						intervalupdate = setInterval(";");
						for (var i = 0 ; i < intervalupdate ; i++) {
						    clearInterval(i); 
						}
						setInterval("dialog_show()",1000*5);
					}
				}
				if(t_name.indexOf("getcanunlock_")>-1){
					var n=t_name.split('_')[1];
					var as = _q_appendData("view_cuc", "", true);
					if (as[0] != undefined){//是否有資料
						if(as[0].cubno==''){
							$('#cucs_cubno'+n).text('');
							$('#cucs_chk'+n).prop("checked",false).parent().parent().find('td').css('background', 'lavender');
							$('#cucs_tr'+n+' .co1').css('background-color', 'antiquewhite');
                            $('#cucs_tr'+n+' .co2').css('background-color', 'lightpink');
                            $('#cucs_tr'+n+' .co3').css('background-color', 'lightsalmon');
							alert('該筆排程已被解除鎖定!!');
						}else if(as[0].cubno!='' && as[0].cubno.split('##')[0].toUpperCase() != r_userno.toUpperCase()){//其他人被鎖定
							$('#cucs_cubno'+n).text(as[0].cubno);
							$('#cucs_chk'+n).prop("checked",false).attr('disabled', 'disabled').parent().parent().find('td').css('background', 'lavender');
							$('#cucs_tr'+n+' .co1').css('background-color', 'antiquewhite');
                            $('#cucs_tr'+n+' .co2').css('background-color', 'lightpink');
                            $('#cucs_tr'+n+' .co3').css('background-color', 'lightsalmon');
							alert('該筆排程已被鎖定!!');
						}else{//自己鎖定的資料
                        	//取消鎖定資料
                            q_func('qtxt.query.unlock', 'cuc_vu.txt,unlock,'+r_accy+';'+$('#cucs_noa'+n).text()+';'+$('#cucs_noq'+n).text()+';'+r_userno.toUpperCase()+';'+r_name);
                            $('#cucs_chk'+n).prop("checked",false).parent().parent().find('td').css('background', 'lavender');
                            $('#cucs_tr'+n+' .co1').css('background-color', 'antiquewhite');
                            $('#cucs_tr'+n+' .co2').css('background-color', 'lightpink');
                            $('#cucs_tr'+n+' .co3').css('background-color', 'lightsalmon');
                            $('#cucs_cubno'+n).text('');
						}
					}else{
						$('#cucs_chk'+n).prop("checked",false).attr('disabled', 'disabled').parent().parent().find('td').css('background', 'lavender');
						$('#cucs_tr'+n+' .co1').css('background-color', 'antiquewhite');
                        $('#cucs_tr'+n+' .co2').css('background-color', 'lightpink');
                        $('#cucs_tr'+n+' .co3').css('background-color', 'lightsalmon');	
						alert('該筆排程已完工!!');
					}
					//刪除暫存資料
					for(var i =0 ;i<chk_cucs.length;i++){
                    	if(chk_cucs[i].noa==$('#cucs_noa'+n).text() && chk_cucs[i].noq==$('#cucs_noq'+n).text()){
                        	chk_cucs.splice(i, 1);
                        	break;
                        }
					}
					//關閉欄位修改
					$('#textXmount_'+n).val('').attr('disabled', 'disabled');
					$('#textXcount_'+n).val('').attr('disabled', 'disabled');
					$('#textXweight_'+n).val('').attr('disabled', 'disabled');
					$('#combXclass_'+n).attr('disabled', 'disabled');
					$('#combXbtime_'+n).attr('disabled', 'disabled');
					$('#combXetime_'+n).attr('disabled', 'disabled');
					
					var cucsno=$('#cucs_noa' + n).text();
					var eweight=dec($('#cucs_eweight' + n).text());
					var erate=q_div(dec($('#cucs_eweight' + n).text()),dec($('#cucs_weight' + n).text()));
					//1126 完工達到97% 呈現灰色
					if(cucsno!='' && erate<=0.03){
						$('#cucs_tr'+n).find('td').css('background', 'lightgrey');
					}
					//Unlock();
					tot_xweight_refresh();
					
					if(chk_cucs.length==0){
						intervalupdate = setInterval(";");
						for (var i = 0 ; i < intervalupdate ; i++) {
						    clearInterval(i); 
						}
						intervalupdate=setInterval("cucsupdata()",1000*60);
						setInterval("dialog_show()",1000*5);
					}else{
						//clearInterval(intervalupdate);
						intervalupdate = setInterval(";");
						for (var i = 0 ; i < intervalupdate ; i++) {
						    clearInterval(i); 
						}
						setInterval("dialog_show()",1000*5);
					}
				}
			}
			
			var func_cubno='';
			var nouno_noa=[];
			function q_funcPost(t_func, result) {
                switch(t_func) {
                	case 'qtxt.query.unlockall':
                			//畫面刷新
                			cucsupdata();
                		break;
                	case 'qtxt.query.cucstocub':
                		var as = _q_appendData("tmp0", "", true, true);
                        if (as[0] != undefined) {
                        	func_cubno=as[0].cubno;
                        	if(func_cubno.length>0){
	                        	q_func('cub_post.post', r_accy + ',' + encodeURI(func_cubno) + ',1');
	                        	q_func( 'barvu.gen1', func_cubno+','+$('#combMechno2').val());
	                        	func_cubno='';
                        	}else{
                        		alert('加工單產生失敗!!');
                        	}
                		}
                		break;
					case 'cub_post.post':
						//alert('加工單產生完畢!!'); 1126拿掉提示
						//1123 保持鎖定狀態，故chk_cucs資料不清空,入庫資料清空//1125完工後件數仍預設帶入1件// 1126取消
						chk_cucs=[];
						/*for (var i=0;i<chk_cucs.length;i++){
                    		chk_cucs[i].xmount=1;
							chk_cucs[i].xcount='';
							chk_cucs[i].xweight='';
                    	}*/
						//更新畫面
						cucsupdata();
						$('#textMemo').val('');//1117 欄位要清空
						//並重新啟動刷新
						intervalupdate = setInterval(";");
						for (var i = 0 ; i < intervalupdate ; i++) {
						    clearInterval(i); 
						}
						intervalupdate=setInterval("cucsupdata()",1000*60);
						setInterval("dialog_show()",1000*5);
						break;
					case 'qtxt.query.cucttocubt':
						var as = _q_appendData("tmp0", "", true, true);
						if (as[0] != undefined) {
                        	func_cubno=as[0].cubno;
                        	q_func('cub_post.post.cubt', r_accy + ',' + encodeURI(func_cubno) + ',1');
                        	Unlock();
                        	alert('領料完成!!');
                		}
						break;
					case 'cub_post.post.cubt':
						//將領料資料清空
						$('#cuct_table .minut').each(function() {
							var n=$(this).attr('id').split('_')[1];
							$(this).click();
							$('#textProduct_'+n).val('鋼筋');
							$('#textUcolor_'+n).val('板料');
	                    });
						break;
					case 'qtxt.query.enda':
						//刪除核取的資料
						for(var j=0;j<chk_cucs.length;j++){
		                    if(t_endanoa==chk_cucs[j]['noa'] && t_endanoq==chk_cucs[j]['noq']){
		                    	chk_cucs.splice(j, 1);
		                    	j--;
		                    	t_endanoa='';
		                    	t_endanoq='';
                        		break;
		                    }
						}
						t_mins_count--;
						//更新畫面
						if(t_mins_count<=0)
							cucsupdata();
						break;
					case 'qtxt.query.cucutocubs':
						//入庫
						var as = _q_appendData("tmp0", "", true, true);
						if (as[0] != undefined) {
                        	func_cubno=as[0].cubno;
                        	if(func_cubno.length>0){
	                        	q_func('cub_post.post.2', r_accy + ',' + encodeURI(func_cubno) + ',1');
	                        	q_func( 'barvu.gen1', func_cubno+','+$('#combMechno2').val());
	                        	func_cubno='';
                        	}else{
                        		alert('入庫失敗!!');
                        	}
                		}
						break;
					case 'cub_post.post.2':
						Unlock();
                        alert('入庫完成!!');
                        $('#cucu_table .minut').each(function() {
							$(this).click();
							var n=$(this).attr('id').split('__')[1];
							$(this).click();
							$('#textProduct__'+n).val('鋼筋');
							$('#textUcolor__'+n).val('');
	                    });
						//更新畫面
						cucsupdata();
						break;
					case 'qtxt.query.cubnouno':
						var as = _q_appendData("tmp0", "", true, true);
						if (as[0] != undefined) {
							var t_cubno=as[0].cubno;
							var t_err=as[0].err;
							if(t_cubno!='')
								q_func('cub_post.post.nouno', r_accy + ',' + encodeURI(t_cubno) + ',1');
							if(t_err.length>0)
								alert(t_err.replace("\\n","\n"));
						}
						break;
					case 'cub_post.post.nouno':
						$('#div_nouno').hide();
						$('#textNouno').val();
						alert("批號領料完成!!");
						break;
                }
                /*if(t_func.indexOf('qtxt.query.getweight_')>-1){
                	var n=t_func.split('_')[1];
                	$('#textAvgweight_'+n).focusin();
                	var as = _q_appendData("tmp0", "", true, true);
					if (as[0] != undefined) {
						var t_weight=0,t_mount=0;
						for (var i=0;i<as.length;i++){
							t_weight=q_add(t_weight,dec(as[0].weight));
							t_mount=q_add(t_mount,dec(as[0].mount));
						}
						$('#lblMount_'+n).text(t_mount);
						$('#lblWeight_'+n).text(t_weight);
						$('#textAvgweight_'+n).val(round(q_div(t_weight,t_mount),3));
						
						if(dec($('#textGmount_'+n).val())>t_mount){
							alert('領料件數大於庫存件數!!');
							$('#textGmount_'+n).val(0);
						}
						
						if(dec($('#textGweight_'+n).val())>t_weight){
							alert('領料重量大於庫存重量!!');
							$('#textGmount_'+n).val(0);
						}
						
						$('#textGweight_'+n).val(q_mul(dec($('#textGmount_'+n).val()),round(q_div(t_weight,t_mount),3)));
					}else{
						$('#textAvgweight_'+n).val(0);
						$('#textGweight_'+n).val(0);
					}
                }*/
                if(t_func.indexOf('qtxt.query.getweight_')>-1){
                	var n=t_func.split('_')[1];
                	var as = _q_appendData("tmp0", "", true, true);
					if (as[0] != undefined) {
						var t_weight=0,t_mount=0;
						for (var i=0;i<as.length;i++){
							t_weight=q_add(t_weight,dec(as[0].weight));
							t_mount=q_add(t_mount,dec(as[0].mount));
						}
						$('#lblMount_'+n).text(t_mount);
						$('#lblWeight_'+n).text(t_weight);
						if(t_mount<=0){
							$('#textAvgweight_'+n).val(0);
						}else{
							$('#textAvgweight_'+n).val(round(q_div(t_weight,t_mount),3));
						}
						
						if(dec($('#textGmount_'+n).val())>t_mount){
							alert('領料件數大於庫存件數!!');
							$('#textGmount_'+n).val(0);
							$('#textMemo_'+n).focus();
						}
						
						if(dec($('#textGmount_'+n).val())>0 && dec($('#textGmount_'+n).val())==t_mount && dec($('#textGweight_'+n).val())!=t_weight){
							$('#textGweight_'+n).val(t_weight);
						}
						
						if(dec($('#textGweight_'+n).val())>t_weight){
							alert('領料重量大於庫存重量!!');
							$('#textGmount_'+n).val(0);
							$('#textMemo_'+n).focus();
						}
						
						if(dec($('#textGmount_'+n).val())>0 && dec($('#textGmount_'+n).val())==t_mount){
							$('#textGweight_'+n).val(t_weight);
						}else{
							if(dec(t_mount)==0){
								$('#textGweight_'+n).val(0);
							}else{
								$('#textGweight_'+n).val(q_mul(dec($('#textGmount_'+n).val()),round(q_div(t_weight,t_mount),3)));
							}
						}
					}else{
						alert('無此物品!!');
						$('#textMemo_'+n).focus();
						$('#textGweight_'+n).val(0);
						$('#textGmount_'+n).val(0);
						$('#textAvgweight_'+n).val(0);
					}
                }
                if(t_func.indexOf('qtxt.query.cuctstkupdate_')>-1 && stkupdate>0){
                	stkupdate=stkupdate-1;
                	var n=t_func.split('_')[1];
                	$('#textAvgweight_'+n).focusin();
                	var as = _q_appendData("tmp0", "", true, true);
					if (as[0] != undefined) {
						var t_weight=0,t_mount=0;
						for (var i=0;i<as.length;i++){
							t_weight=q_add(t_weight,dec(as[0].weight));
							t_mount=q_add(t_mount,dec(as[0].mount));
						}
						$('#lblMount_'+n).text(t_mount);
						$('#lblWeight_'+n).text(t_weight);
						if(t_mount<=0)
							$('#textAvgweight_'+n).val(0);
						else
							$('#textAvgweight_'+n).val(round(q_div(t_weight,t_mount),3));
						
						if(dec($('#textGmount_'+n).val())>t_mount){
							$('#textGmount_'+n).val(0);
						}
						
						if(dec($('#textGmount_'+n).val())>0 && dec($('#textGmount_'+n).val())==t_mount && dec($('#textGweight_'+n).val())!=t_weight){
							$('#textGweight_'+n).val(t_weight);
						}
						
						if(dec($('#textGweight_'+n).val())>t_weight){
							$('#textGmount_'+n).val(0);
						}
						
						if(dec($('#textGmount_'+n).val())>0 && dec($('#textGmount_'+n).val())==t_mount ){
							$('#textGweight_'+n).val(t_weight);
						}else{
							if(dec(t_mount)==0){
								$('#textGweight_'+n).val(0);
							}else{
								$('#textGweight_'+n).val(q_mul(dec($('#textGmount_'+n).val()),round(q_div(t_weight,t_mount),3)));
							}
						}
					}else{
						$('#textAvgweight_'+n).val(0);
						$('#textGweight_'+n).val(0);
						$('#textGmount_'+n).val(0);
					}
					
					if(stkupdate==0){
						//直接將cuct 加到cuct
						var t_datea=emp($('#textDatea').val())?'#non':$('#textDatea').val();
	                    var t_mechno=emp($('#combMechno').val())?'#non':$('#combMechno').val();
	                    var t_memo=emp($('#textMemo').val())?'#non':$('#textMemo').val();
						var ts_bbt='';
	                    var bbtrow=document.getElementById("cuct_table").rows.length-1;
	                    var hasbbs=false;
	                    for(var j=0;j<bbtrow;j++){
	                    	var ts_product=$('#textProduct_'+j).val();
		                	var ts_ucolor=$('#textUcolor_'+j).val();
							var ts_spec=$('#textSpec_'+j).val();
							var ts_size=$('#textSize_'+j).val();
							var ts_lengthb=$('#textLengthb_'+j).val();
							var ts_class=$('#textClass_'+j).val();
							var ts_gmount=$('#textGmount_'+j).val();
							var ts_gweight=$('#textGweight_'+j).val();
							var ts_avgweight=$('#textAvgweight_'+j).val();
							var ts_memo=$('#textMemo_'+j).val();
																
							if(!emp(ts_product) || !emp(ts_ucolor) || !emp(ts_spec) || !emp(ts_size) || !emp(ts_lengthb) || !emp(ts_class)){
								hasbbs=true; //有資料
								if (dec(ts_gweight)>0 && dec(ts_avgweight)>0){ //重量>0
									ts_bbt=ts_bbt
									+ts_product+"^@^"
									+ts_ucolor+"^@^"
									+ts_spec+"^@^"
									+ts_size+"^@^"
									+dec(ts_lengthb)+"^@^"
									+ts_class+"^@^"
									+dec(ts_gmount)+"^@^"
									+dec(ts_gweight)+"^@^"
									+ts_memo+"^@^"
									+"^#^";
		                    	}
							}
	                    }
	                    if(!hasbbs){
							alert('無領料資料');
							Unlock();
	                    }else if(ts_bbt.length==0){
	                    	alert('領料重量等於零。');
	                    	Unlock();
	                    }else{
	                    	q_func('qtxt.query.cucttocubt', 'cuc_vu.txt,cucttocubt,'
	                   		+r_accy+';'+t_datea+';'+t_mechno+';'+t_memo+';'+r_userno.toUpperCase()+';'+r_name+';'+ts_bbt);
	                    }
					}
                }
                //bbsbbt有資料 轉cub 檢查庫存
                if(t_func.indexOf('qtxt.query.cucsstkcuct_')>-1 && stkupdate>0){
                	stkupdate=stkupdate-1;
                	var n=t_func.split('_')[1];
                	$('#textAvgweight_'+n).focusin();
                	var as = _q_appendData("tmp0", "", true, true);
					if (as[0] != undefined) {
						var t_weight=0,t_mount=0;
						for (var i=0;i<as.length;i++){
							t_weight=q_add(t_weight,dec(as[0].weight));
							t_mount=q_add(t_mount,dec(as[0].mount));
						}
						$('#lblMount_'+n).text(t_mount);
						$('#lblWeight_'+n).text(t_weight);
						if(t_mount<=0)
							$('#textAvgweight_'+n).val(0);
						else
							$('#textAvgweight_'+n).val(round(q_div(t_weight,t_mount),3));
						
						if(dec($('#textGmount_'+n).val())>t_mount){
							alert('領料件數大於庫存件數!!');
							$('#textGmount_'+n).val(0);
							stkupdate=-1;
						}
						
						if(dec($('#textGmount_'+n).val())>0 && dec($('#textGmount_'+n).val())==t_mount && dec($('#textGweight_'+n).val())!=t_weight){
							$('#textGweight_'+n).val(t_weight);
						}
						
						if(dec($('#textGweight_'+n).val())>t_weight){
							alert('領料重量大於庫存重量!!');
							$('#textGmount_'+n).val(0);
							$('#textGweight_'+n).val(0);
							stkupdate=-1;
						}
						if(dec($('#textGmount_'+n).val())>0 && dec($('#textGmount_'+n).val())==t_mount){
							$('#textGweight_'+n).val(t_weight);
						}else{
							if(dec(t_mount)==0){
								$('#textGweight_'+n).val(0);
							}else{
								$('#textGweight_'+n).val(q_mul(dec($('#textGmount_'+n).val()),round(q_div(t_weight,t_mount),3)));
							}
						}
					}else{
						$('#textAvgweight_'+n).val(0);
						$('#textGweight_'+n).val(0);
						$('#textGmount_'+n).val(0);
						alert('物品已被領料完!!');
						stkupdate=-1;
					}
					
					if(stkupdate==0){
						var t_datea=emp($('#textDatea').val())?'#non':$('#textDatea').val();
	                    var t_mechno=emp($('#combMechno').val())?'#non':$('#combMechno').val();
	                    var t_memo=emp($('#textMemo').val())?'#non':$('#textMemo').val();
	                    
	                    var t_noa='';
                    	var t_noq='';
                    	var t_xmount='';
                    	var t_xcount='';
                    	var t_xweight='';
                    	var t_err='';
                    	for (var i=0;i<chk_cucs.length;i++){
                    		if(dec(chk_cucs[i]['xmount'])>0 || dec(chk_cucs[i]['xweight'])>0){
	                    		t_noa=t_noa+chk_cucs[i]['noa']+'^';
								t_noq=t_noq+chk_cucs[i]['noq']+'^';
								t_xmount=t_xmount+dec(chk_cucs[i]['xmount'])+'^';
			    				t_xcount=t_xcount+dec(chk_cucs[i]['xcount'])+'^';
								t_xweight=t_xweight+dec(chk_cucs[i]['xweight'])+'^';
							}
                    	}
	                    			
	                    //表身資料
	                    var ts_bbt='';
	                    var bbtrow=document.getElementById("cuct_table").rows.length-1;
	                    for(var j=0;j<bbtrow;j++){
	                    	var ts_product=$('#textProduct_'+j).val();
		                	var ts_ucolor=$('#textUcolor_'+j).val();
							var ts_spec=$('#textSpec_'+j).val();
							var ts_size=$('#textSize_'+j).val();
							var ts_lengthb=$('#textLengthb_'+j).val();
							var ts_class=$('#textClass_'+j).val();
							var ts_gmount=$('#textGmount_'+j).val();
							var ts_gweight=$('#textGweight_'+j).val();
							var ts_avgweight=$('#textAvgweight_'+j).val();
							var ts_memo=$('#textMemo_'+j).val();
										
							if(	(!emp(ts_product) || !emp(ts_ucolor) || !emp(ts_spec) || !emp(ts_size) || !emp(ts_lengthb) || !emp(ts_class))
							&&dec(ts_gweight)>0 && dec(ts_avgweight)>0){
								ts_bbt=ts_bbt
								+ts_product+"^@^"
								+ts_ucolor+"^@^"
								+ts_spec+"^@^"
								+ts_size+"^@^"
								+dec(ts_lengthb)+"^@^"
								+ts_class+"^@^"
								+dec(ts_gmount)+"^@^"
								+dec(ts_gweight)+"^@^"
								+ts_memo+"^@^"
								+"^#^";
							}
						}
	                    if(ts_bbt.length==0){
	                    	ts_bbt='#non'
						}
	                    q_func('qtxt.query.cucstocub', 'cuc_vu.txt,cucstocub,'
	                    +r_accy+';'+t_datea+';'+t_mechno+';'+t_memo+';'
	                    +r_userno.toUpperCase()+';'+r_name+';'+t_noa+';'+t_noq+';'+t_xmount+';'+t_xcount+';'+t_xweight+';'+ts_bbt+';1');
	                    //取消刷新
	                    //clearInterval(intervalupdate);
					}
                }
			}
			
			function q_boxClose(s2) {
				var ret;
				switch (b_pop) {
					case 'cuc_vu_b':
						b_ret = getb_ret();
						if(b_ret && b_ret[0]!=undefined){
							$('#combCucno').val(b_ret[0].noa);
						}
						break;
					case q_name + '_s':
						q_boxClose2(s2);
						break;
				}
				b_pop = '';
			}
			
			function tot_xweight_refresh() {
				var tot_xweight=0;
				$('.xweight').each(function(index) {
					tot_xweight=q_add(tot_xweight,dec($(this).val()));
				});
		                        
				if(tot_xweight!=0)
		        	$('.total_xweight').text(tot_xweight);
				else
					$('.total_xweight').text('');
			}
			
			function cucs_refresh() {
				var bbsrow=document.getElementById("cucs_table").rows.length-1;
				for (var i=0;i<bbsrow;i++){
					var cubno=$('#cucs_cubno' + i).text();
					var cucsno=$('#cucs_noa' + i).text();
					var eweight=dec($('#cucs_eweight' + i).text());
					$('#textXmount_'+i).val('').attr('disabled', 'disabled');
					$('#textXcount_'+i).val('').attr('disabled', 'disabled');
					$('#textXweight_'+i).val('').attr('disabled', 'disabled');
					$('#combXclass_'+i).attr('disabled', 'disabled');
					$('#combXbtime_'+i).attr('disabled', 'disabled');
					$('#combXetime_'+i).attr('disabled', 'disabled');
					if(cubno!=''){
						var lock_time=cubno.split('##')[3]!=undefined?cubno.split('##')[3]:'';
						var islock=false;
						if(lock_time.length>0){
							islock=true;
							var now_time = new Date();
							lock_time = new Date(lock_time);
							var diff = now_time - lock_time;
							if(diff>1000 * 60 * 15) //超過15分表示已解除鎖定
								islock=false;
						}
						if(islock && cubno.split('##')[0].toUpperCase()!=r_userno.toUpperCase()){//其他人鎖定
							var mechno=cubno.split('##')[2]!=undefined?cubno.split('##')[2]:'';
							var tt_mech=t_mech.split(',');
							for(var k=0;k<tt_mech.length;k++){
								if(tt_mech[k].split('@')[0]==mechno){
									mechno=tt_mech[k].split('@')[1];
									break;
								}
							}
							
							$('#cucs_lbla'+i).text(mechno);
							$('#cucs_chk' + i).attr('disabled', 'disabled');
                            $('#cucs_chk'+i).prop('checked',false).parent().parent().find('td').css('background', 'lavender');
                            $('#cucs_tr'+i+' .co1').css('background-color', 'antiquewhite');
                            $('#cucs_tr'+i+' .co2').css('background-color', 'lightpink');
                            $('#cucs_tr'+i+' .co3').css('background-color', 'lightsalmon');
                            $('#cucs_mins' + i).attr('disabled', 'disabled');
                            $('#cucs_waste' + i).attr('disabled', 'disabled');
                            $('#cucs_hours' + i).attr('disabled', 'disabled');
						}else if (islock && cubno.split('##')[0].toUpperCase()==r_userno.toUpperCase()){//自己鎖定
							$('#cucs_lbla'+i).text('');
							$('#cucs_chk' + i).removeAttr('disabled');
                            $('#cucs_chk'+i).prop('checked',true).parent().parent().find('td').css('background', 'darkturquoise');
                            $('#combMechno').val(cubno.split('##')[2]!=undefined?cubno.split('##')[2]:'');
                            $('#cucs_mins' + i).removeAttr('disabled');
                            $('#cucs_waste' + i).removeAttr('disabled');
                            $('#cucs_hours' + i).removeAttr('disabled');
                            //text寫入
                            for(var j =0 ;j<chk_cucs.length;j++){
                            	if(chk_cucs[j].noa==$('#cucs_noa'+i).text() && chk_cucs[j].noq==$('#cucs_noq'+i).text()){
		                            $('#textXmount_'+i).val(chk_cucs[j].xmount).removeAttr('disabled');
									$('#textXcount_'+i).val(chk_cucs[j].xcount).removeAttr('disabled');
									$('#textXweight_'+i).val(chk_cucs[j].xweight).removeAttr('disabled');
									$('#combXclass_'+i).removeAttr('disabled');
									$('#combXbtime_'+i).removeAttr('disabled');
									$('#combXetime_'+i).removeAttr('disabled');
									break;
								}
							}
						}else{ //超過鎖定時間
							$('#cucs_lbla'+i).text('');
							$('#cucs_chk' + i).removeAttr('disabled');
							$('#cucs_chk'+i).prop('checked',false).parent().parent().find('td').css('background', 'lavender');
							$('#cucs_mins' + i).removeAttr('disabled');
							$('#cucs_waste' + i).removeAttr('disabled');
                            $('#cucs_hours' + i).removeAttr('disabled');
							$('#cucs_tr'+i+' .co1').css('background-color', 'antiquewhite');
                            $('#cucs_tr'+i+' .co2').css('background-color', 'lightpink');
                            $('#cucs_tr'+i+' .co3').css('background-color', 'lightsalmon');
						}
					}else{//無人鎖定
						$('#cucs_lbla'+i).text('');
						$('#cucs_chk' + i).removeAttr('disabled');
						$('#cucs_chk'+i).prop('checked',false).parent().parent().find('td').css('background', 'lavender');
						$('#cucs_mins' + i).removeAttr('disabled');
						$('#cucs_waste' + i).removeAttr('disabled');
                        $('#cucs_hours' + i).removeAttr('disabled');
						$('#cucs_tr'+i+' .co1').css('background-color', 'antiquewhite');
						$('#cucs_tr'+i+' .co2').css('background-color', 'lightpink');
						$('#cucs_tr'+i+' .co3').css('background-color', 'lightsalmon');
					}
					
					var erate=q_div(dec($('#cucs_eweight' + i).text()),dec($('#cucs_weight' + i).text()));
					//1126 完工達到97% 呈現灰色
					if(cucsno!='' && erate<=0.03){
						$('#cucs_tr'+i).find('td').css('background', 'lightgrey');
					}
				}
				
				//107/05/31
                if($('#btnFhide1').val()=='成型顯示'){
                	$('.fhide1').hide();
                }else{
                	$('.fhide1').show();
                }
                if($('#btnFhide2').val()=='車牙顯示'){
                	$('.fhide2').hide();
                }else{
                	$('.fhide2').show();
                }
                if($('#btnFhide1').val()=='成型顯示' && $('#btnFhide2').val()=='車牙顯示'){
                	$('#cucs_table').css('font-size','medium');
                	$('#cucs_table2').css('font-size','medium');
                	$('.imghide').hide();
                }else{
                	$('#cucs_table').css('font-size','11px');
                	$('#cucs_table2').css('font-size','11px');
                	$('.imghide').show();
                }
			}

		</script>
		<style type="text/css">
			#dmain {
				overflow: hidden;
			}
			.dview {
				float: left;
				width: 98%;
			}
			.tview {
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
				width: 98%;
				margin: -1px;
				border: 1px black solid;
				border-radius: 5px;
			}
			.tbbm {
				padding: 0px;
				border: 1px white double;
				border-spacing: 0;
				border-collapse: collapse;
				font-size: medium;
				color: blue;
				background: lavender;
				width: 100%;
			}
			.tbbm tr {
				height: 35px;
			}
			.tbbm tr td {
				width: 9%;
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
				width: 71%;
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

			input[type="text"], input[type="button"] {
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
				background: lavender;
				width: 100%;
			}
			.dbbs .tbbs tr {
				height: 35px;
			}
			.dbbs .tbbs tr td {
				text-align: center;
				border: 2px lightgrey double;
			}
			#cucs_table {
                border: 5px solid gray;
                font-size: 11px;
                background-color: white;
            }
            #cucs_table tr {
                height: 30px;
            }
            #cucs_table td {
                /*padding: 2px;*/
                text-align: center;
                border-width: 0px;
                background-color: lavender;
                color: blue;
            }
            #cucs_table .co1{
                background-color: antiquewhite;
            }
            #cucs_table .co2{
                background-color: lightpink;
            }
            #cucs_table .co3{
                background-color: lightsalmon;
            }
            
            #cucs_table2 {
                border: 5px solid gray;
                font-size: 11px;
                background-color: white;
            }
            #cucs_table2 tr {
                height: 30px;
            }
            #cucs_table2 td {
                /*padding: 2px;*/
                text-align: center;
                border-width: 0px;
                background-color: lavender;
                color: blue;
            }
            #cucs_table2 .co1{
                background-color: antiquewhite;
            }
            #cucs_table2 .co2{
                background-color: lightpink;
            }
            #cucs_table2 .co3{
                background-color: lightsalmon;
            }
            
            #cuct_table {
                border: 5px solid gray;
                font-size: medium;
                background-color: white;
            }
            #cuct_table tr {
                height: 30px;
            }
            #cuct_table td {
                padding: 2px;
                text-align: center;
                border-width: 0px;
                background-color: lightblue;
                color: blue;
            }
            
            #cuct_table2 {
                border: 5px solid gray;
                font-size: medium;
                background-color: white;
            }
            #cuct_table2 tr {
                height: 30px;
            }
            #cuct_table2 td {
                padding: 2px;
                text-align: center;
                border-width: 0px;
                background-color: lightblue;
                color: blue;
            }
            
             #cucu_table {
                border: 5px solid gray;
                font-size: medium;
                background-color: white;
            }
            #cucu_table tr {
                height: 30px;
            }
            #cucu_table td {
                padding: 2px;
                text-align: center;
                border-width: 0px;
                background-color: gold;
                color: blue;
            }
            
            #cucu_table2 {
                border: 5px solid gray;
                font-size: medium;
                background-color: white;
            }
            #cucu_table2 tr {
                height: 30px;
            }
            #cucu_table2 td {
                padding: 2px;
                text-align: center;
                border-width: 0px;
                background-color: gold;
                color: blue;
            }
            
		</style>
	</head>
	<body>
		<div id='q_menu'> </div>
		<div id='q_acDiv'> </div>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type='button' id='btnAuthority' name='btnAuthority' style='font-size:16px;' value='權限'/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type='button' id='btnFhide1' style='font-size:16px;display: none;' value='成型顯示'/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type='button' id='btnFhide2' style='font-size:16px;display: none;' value='車牙顯示'/>
		<a id='logout' class="lbl" style="color: coral;cursor: pointer;font-weight: bolder;float: right;">登出</a>
		<BR>
		<a class="lbl">加工日</a>&nbsp;<input id="textDatea" type="text" class="txt" style="width: 100px;" readonly="readonly";/>&nbsp;
		<a class="lbl">人員組別</a>&nbsp;
			<select id="combMechno" class="txt" style="font-size: medium;"> </select>
			<!--<input id="textMechno"  type="text" class="txt " style="width: 100px;"/>
			<input id="textMech"  type="text" class="txt" style="width: 100px;" disabled="disabled"/>-->
		<a class="lbl">機　台</a>&nbsp;
			<select id="combMechno2" class="txt" style="font-size: medium;"> </select>
		<a class="lbl">生產記錄備註</a>&nbsp;<input id="textMemo"  type="text" class="txt" style="width: 270px;"/>
		<input type='button' id='btnCub' style='font-size:16px;' value="入庫"/>
		<input type='button' id='btnCancels' style='font-size:16px;' value="取消鎖定"/>
		<input type='button' id='btnClear' style='font-size:16px;' value="畫面刷新"/>
		<input type='button' id='btnStk' style='font-size:16px;' value="庫存表"/>
		<input type='button' id='btnCubp' style='font-size:16px;' value="料單報表"/>
		<BR>
		<a id="lblCucnoa" class="lbl" style="color: #4297D7;cursor: pointer;font-weight: bolder;">案　號</a>&nbsp;
		<select id="combCucno" class="txt" style="font-size: medium;"> </select>
		&nbsp;<a class="lbl">品　名</a>&nbsp;<!--107/04/11-->
		<select id="combProduct" class="txt" style="font-size: medium;"> </select>
		&nbsp;<a class="lbl">號　數</a>&nbsp;
		<select id="combSize" class="txt" style="font-size: medium;"> </select>
		&nbsp;<a class="lbl">材　質</a>&nbsp;
		<select id="combSpec" class="txt" style="font-size: medium;"> </select>
		&nbsp;<a class="lbl">排　序</a>&nbsp;
		<select id="combOrder" class="txt" style="font-size: medium;"> </select>
		<input type='button' id='btnImport' style='font-size:16px;' value="匯入"/>
		&nbsp;
		<input type='button' id='btnCubp8' style='font-size:16px;' value="生產計劃日程表"/>
		<input type='button' id='btnCubp2' style='font-size:16px;' value="組別加工明細表"/>
		<input type='button' id='btnCubp5' style='font-size:16px;' value="板料領料明細表"/>
		<a style="color: red;display: none;">※機台鎖定時間超過15分鐘將自動解除鎖定</a><!--107/04/11文字隱藏,功能保留-->
		<div id="cucs" style="float:left;width:100%;height:500px;overflow:auto;position: relative;"> </div> 
		<!--<div id="cucs_control" style="width:100%;"> </div>--> 
		<div id="cuct" style="float:left;width:100%;height:80px;overflow:auto;position: relative;"> </div>
		<div id="cucu" style="float:left;width:100%;height:80px;overflow:auto;position: relative;"> </div>
		<div id="div_nouno" style="position:absolute; top:70px; left:840px; display:none; width:400px; background-color: #CDFFCE; border: 1px solid gray;">
			<table id="table_nouno" style="width:100%;" border="1" cellpadding='2'  cellspacing='0'>
				<tr>
					<td style="background-color: #f8d463;width: 150px;" align="center">批號</td>
					<td style="background-color: #f8d463;width: 250px;"><input id="textNouno" type="text" class="txt c1"/></td>
				</tr>
				<tr id='nouno_close'>
					<td align="center" colspan='2'>
						<input id="btnOk_div_nouno" type="button" value="領料">
						<input id="btnClose_div_nouno" type="button" value="取消">
					</td>
				</tr>
			</table>
		</div>
		<div id="dialog" style="position:absolute; top:200px; left:350px;font-size: 30px;color: red;font-weight: bold;">
			<table style="border: 2px solid gray;padding: 50px;background-color: cornsilk;">
				<tr>
					<td>注意事項：</td>
				</tr>
				<tr> 
					<td>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1.請務必輸入正確組別</td>
				</tr>
				<tr>
					<td>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 2.確認所在機台是否正確</td>
				</tr>
				<tr><td> </td></tr>
				<tr style="text-align: center;">
					<td><BR><input type='button' id='btnDialog_close' style='font-size:20px;' value="關閉"/></td>
				</tr>
			</table>
		</div>
	</body>
</html>