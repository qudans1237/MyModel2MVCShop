<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<html>
<head>
<title>���� �����ȸ</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">

<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	
	<!--  ///////////////////////// Bootstrap, jQuery CDN ////////////////////////// -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" >
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" >
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" ></script>
	<script type="text/javascript">
	

function fncGetUserList(currentPage) {
	
	$("#currentPage").val(currentPage)
   
	$("form").attr("method" , "POST").attr("action" , "/purchase/shippingList?menu=${param.menu}").submit();
}
$(function() {
	 
	$( ".ct_list_pop td:nth-child(1)" ).on("click" , function() {
		self.location ="/purchase/getPurchase?tranNo="+$(this).children("input").val();
	});
	
	$( ".ct_list_pop td:nth-child(3)" ).on("click" , function() {
			self.location ="/user/getUser?userId="+$(this).children("input").val();
	});
	
	$( ".ct_list_pop td:nth-child(5)" ).on("click" , function() {
		var tranNo = $(this).children("input").val().trim();
		$.ajax({
			url : "/purchase/json/getPurchase/" + tranNo,
			method : "GET",
			dataType : "json",
			headers : {
				"Accept" : "application/json",
				"Content-Type" : "application/json"
			},
			success : function(JSONData, status) {

				//alert(status);
				//alert("JSONData : \n"+JSONData.tranNo);

				var displayValue = "<h3>" + 
				"��ǰ��ȣ : "+JSONData.purchaseProd.prodNo + "<br/>" +
				"������ �̸� : "+JSONData.purchaseProd.receiverName + "<br/>" +
				"��� : "+ JSONData.quantity + "<br/>" +
				"������ ����ó : "+ JSONData.receiverPhone + "<br/>" +
				"������ �ּ� : "+ JSONData.divyAddr + "<br/>" +
				"���� ��û ����: "+ JSONData.divyRequest + "<br/>" +
				"��������: "+ JSONData.divyDate + "<br/>" +
				"�ֹ���: "+ JSONData.orderDate + "<br/>" +
				"</h3>";

				//alert(displayValue);
				$("h3").remove();
				$("#" + tranNo + "").html(displayValue);
			}
		});
	});
	
	$( ".ct_list_pop td:nth-child(9):contains('����ϱ�')" ).on("click" , function() {
		alert("����ϱ� ��ư " +$(this).children("input").val());
		self.location ="/purchase/updateTranCodeByProd?menu=manage&prodNo="+$(this).children("input").val()+"&tranCode=2";
	});

	$( ".ct_list_pop td:nth-child(11):contains('�ֹ����')"  ).on("click" , function() {
		alert("�ֹ���� ��ư " +$(this).children("input").val());
		self.location ="/purchase/updateTranCodeByProd?menu=manage&prodNo="+$(this).children("input").val()+"&tranCode=4";
	});

$( ".ct_list_pop td:nth-child(1)" ).css("color" , "red");
$( ".ct_list_pop td:nth-child(3)" ).css("color" , "#38610B");
$( ".ct_list_pop td:nth-child(5)" ).css("color" , "#4B8A08");
$("h8").css("color" , "#5FB404");

$(".ct_list_pop:nth-child(4n+6)" ).css("background-color" , "whitesmoke");

});
</script>
</head>

<body bgcolor="#ffffff" text="#000000">
	<!-- ToolBar Start /////////////////////////////////////-->
	<jsp:include page="/layout/toolbar.jsp" />
   	<!-- ToolBar End /////////////////////////////////////-->
<div style="width: 98%; margin-left: 10px;">

<form name="detailForm" >

<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37"><img src="/images/ct_ttl_img01.gif"width="15" height="37"></td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left: 10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">��� �����ȸ</td>
				</tr>
			</table>
		</td>
		<td width="12" height="37"><img src="/images/ct_ttl_img03.gif"	width="12" height="37"></td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0"	style="margin-top: 10px;">
	<tr>
		<td colspan="11">��ü ${resultPage.totalCount} �Ǽ�, ���� ${resultPage.currentPage } ������</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="140">�ֹ���ȣ<br><h7 >(no click:������)</h7></td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">ȸ��ID<br><h7 >(id click:������)</h7></td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">�ֹ�����</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">�����ݾ�</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">�����Ȳ</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="100">�ֹ����</td>
		<td class="ct_line02"></td>
	</tr>
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>

	<c:set var = "i" value = "0"/>
	<c:forEach var ="purchase" items ="${list }">
		<c:set var="i"  value = "${i+1 }"/>
		<tr class="ct_list_pop">
		<td align="center">
		<input type="hidden" name="tranNo"  value="${purchase.tranNo }" />
		${purchase.tranNo}
		</td>
		<td></td>
		<td align="left">
		<input type="hidden" name="userId"  value="${purchase.buyer.userId}" />
		${purchase.buyer.userId}
		</td>
		<td></td>
		<td align="left">${purchase.purchaseProd.prodName}<input type="hidden" name="tranNo"  value="${purchase.tranNo }" /></td>
		<td></td>
		<td align="left">
		<c:if test="${purchase.quantity>=1 }">${(purchase.purchaseProd.price)*(purchase.quantity)}</c:if>
		<c:if test="${purchase.quantity==0 }">${purchase.purchaseProd.price}</c:if>
		��
		</td>
		<td></td>
		<td align="left">
				����
				<c:if test="${! empty purchase.purchaseProd.proTranCode && purchase.purchaseProd.proTranCode=='1  '}">
					<c:if test="${user.role=='admin' && param.menu=='manage'}">���ſϷ� ���� �Դϴ�.
					<h8>����ϱ�</h8>
					<input type="hidden" name="prodNo" value="${purchase.purchaseProd.prodNo}" />
					</c:if>
				</c:if>
				
				<c:if test="${! empty purchase.purchaseProd.proTranCode && purchase.purchaseProd.proTranCode=='2  '}">
					<c:if test="${user.role=='admin' && param.menu=='manage'}">����� ���� �Դϴ�.</c:if>
				</c:if>
				
				<c:if test="${! empty purchase.purchaseProd.proTranCode && purchase.purchaseProd.proTranCode=='3  '}">
					<c:if test="${user.role=='admin' && param.menu=='manage'}">��ۿϷ� ���� �Դϴ�.</c:if>
				</c:if>
				
				<c:if test="${! empty purchase.purchaseProd.proTranCode && purchase.purchaseProd.proTranCode=='4  '}">
					<c:if test="${user.role=='admin' && param.menu=='manage'}">�ֹ���� ���� �Դϴ�.</c:if>
				</c:if>
			</td>	
			<td></td>
			<td align="left"><c:if test="${! empty purchase.purchaseProd.proTranCode && purchase.purchaseProd.proTranCode=='1  '}">
			<h8>�ֹ����</h8><input type="hidden" name="prodNo" value="${purchase.purchaseProd.prodNo }" /></c:if>
			</td>
		</tr>
		<tr>
			<td id = "${purchase.tranNo }" colspan="11" bgcolor="D6D7D6" height="1"></td>
		</tr>
	</c:forEach>
</table>	
	
<!--  ������ Navigator ���� -->

<table width="100%" border="0" cellspacing="0" cellpadding="0"	style="margin-top:10px;">
	<tr>
		<td align="center">
		   <input type="hidden" id="currentPage" name="currentPage" value=""/>
	
			<jsp:include page="../common/pageNavigator.jsp"/>	
			
    	</td>
	</tr>
</table>
<!--  ������ Navigator �� -->

</form>

</div>

</body>
</html>