<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script type="text/javascript" charset="utf-8" src="/js/kindeditor-4.1.7/kindeditor-all-min.js"></script>
<script type="text/javascript" charset="utf-8" src="/js/kindeditor-4.1.7/lang/zh_CN.js"></script>
    
<div style="padding:10px">
	<form id="itemEditForm" class="itemForm" method="post">
        <input type="hidden" name="id"/>
		<table cellpadding="5">
			<tbody>
				<tr>
					<td>商品类目：</td>
					<td>
						<a href="javascript:void(0)" class="easyui-linkbutton selectItemCat">
							选择类目
						</a>
						<input type="text" name="cid" style="width: 280px;"/>
					</td>
				</tr>
				<tr>
					<td>商品标题：</td>
					<td>
						<input class="easyui-textbox" type="text" name="title" data-options="required:true" style="width: 280px;"/>
					</td>
				</tr>
				<tr>
					<td>商品卖点：</td>
					<td>
						<input class="easyui-textbox" name="sellPoint" data-options="multiline:true, validType:'length[0,150]'" style="width: 280px; height: 60px;"/>
					</td>
				</tr>
				<tr>
					<td>商品价格：</td>
					<td>
						<input class="easyui-numberbox" type="text" name="priceView" data-options="min:1, max:99999999, precision:2, required:true"/>
						<input type="hidden" name="price"/>
					</td>
				</tr>
				<tr>
					<td>库存数量：</td>
					<td>
						<input class="easyui-numberbox" type="text" name="num" data-options="min:1, max:99999999, precision:0, required:true"/>
					</td>
				</tr>
				<tr>
					<td>条形码：</td>
					<td>
						<input class="easyui-textbox" type="text" name="barcode" data-options="validType:'length[1,30]'"/>
					</td>
				</tr>
				<tr>
					<td>商品图片：</td>
					<td>
						<a href="javascript:void(0)" class="easyui-linkbutton picFileUpload">上传图片</a>
						<input type="hidden" name="image"/>
					</td>
				</tr>
				<tr>
					<td>商品描述：</td>
					<td>
						<textarea style="width:800px;height:300px;visibility:hidden;" name="desc"></textarea>
                    </td>
				</tr>
				<tr class="params hide">
					<td>商品规格：</td>
					<td>
					</td>
				</tr>
			</tbody>
		</table>
		<input type="hidden" name="itemParams"/>
        <input type="hidden" name="itemParamId"/>
	</form>
    
	<div style="padding:5px">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="submitForm()">保存</a>
	</div>
</div>

<script type="text/javascript">
	var itemEditEditor;
	
	$(function() {
	    //实例化编辑器
	    itemEditEditor = KindEditorUtil.createEditor("#itemEditForm [name=desc]");
	});
	
	function submitForm() {
	    if(!$("#itemEditForm").form("validate")) {
	        //$.messager.alert("提示", "表单还未填写完成！");
	        alert("表单还未填写完成！");
	        return;
	    }
	  	//转化价格单位，将元转化为分
		//此处有浮点数计算问题 处理 zain 16/10/07
		var priceView = $("#itemEditForm [name=priceView]").val();
		if(priceView != "" || priceView != null || priceView != undefined) {
			var prices = priceView.split(".");
			var price = "";
			if(prices.length == 2) {
				price += prices[0];
				price += prices[1];
			} 
			if(prices.length == 1) {
			    price += prices[0];
			} 
			if(prices.length == 0) {
			    price += "00";
			}
				
			$("#itemEditForm [name=price]").val(price);
		} else {
			alert("金额有误！");
		}
	    itemEditEditor.sync();
	    
	    var paramJson = [];
	    $("#itemEditForm .params li").each(function(i, e) {
	        var trs = $(e).find("tr");
	        var group = trs.eq(0).text();
	        var ps = [];
	        for(var i=1; i<trs.length; i++) {
	            var tr = trs.eq(i);
	            ps.push({
	                "k" : $.trim(tr.find("td").eq(0).find("span").text()),
	                "v" : $.trim(tr.find("input").val())
	            });
	        }
	        paramJson.push({
	            "group" : group,
	            "params" : ps
	        });
	    }); //function(i, e) over
	    paramJson = JSON.stringify(paramJson);
	    
	    $("#itemEditForm [name=itemParams]").val(paramJson);
	    
	    $.post("/item/update", $("#itemEditForm").serialize(), function(data) {
	        if(data.status == 200) {
	            alert("修改商品成功");
	            //$.message.alert("提示", "修改商品成功", "info", function() {
	                $("#itemEditWindow").window("close");
	                $("#itemList").datagrid("reload");
	            //});
	        }
	    })
	    
	    
	}
	
</script>
