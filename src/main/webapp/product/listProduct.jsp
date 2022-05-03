<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page pageEncoding="EUC-KR"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
<head>
<title></title>

<meta charset="EUC-KR">

<!-- ���� : http://getbootstrap.com/css/   ���� -->
<meta name="viewport" content="width=device-width, initial-scale=1.0" />

<!--  ///////////////////////// Bootstrap, jQuery CDN ////////////////////////// -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css">
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>


<!-- Bootstrap Dropdown Hover CSS -->
<link href="/css/animate.min.css" rel="stylesheet">
<link href="/css/bootstrap-dropdownhover.min.css" rel="stylesheet">
<!-- Bootstrap Dropdown Hover JS -->
<script src="/javascript/bootstrap-dropdownhover.min.js"></script>


<!-- jQuery UI toolTip ��� CSS-->
<link rel="stylesheet"
	href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<!-- jQuery UI toolTip ��� JS-->
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<!--  ///////////////////////// CSS ////////////////////////// -->
<style>
body {
	padding-top: 50px;
}
</style>

<script type="text/javascript">
	//fncGetProductList(currentPage)
	function fncGetList(currentPage) {
		$("#currentPage").val(currentPage)
		$("form").attr("method", "POST").attr("action", "/product/listProduct")
				.submit();
	}
	$(function() {
		//==> DOM Object GET 3���� ��� ==> 1. $(tagName) : 2.(#id) : 3.$(.className)
		//$( "button.btn.btn-default" ).on("click" , function() {
		//	fncGetUserList(1);
		//});
	});

	$(function() {

		$("td:nth-child(2)")
				.on(
						"click",
						function() {
							//alert(  $(this).children("input").val().trim() );
							var prodNo = $(this).children("input").val().trim();
							$
									.ajax({
										url : "/product/json/getProduct/"
												+ prodNo,
										method : "GET",
										dataType : "json",
										headers : {
											"Accept" : "application/json",
											"Content-Type" : "application/json"
										},
										success : function(JSONData, status) {

											//	alert(status);
											// 	alert("JSONData : \n"+JSONData.prodNo);

											var displayValue = "<h3>"
													+ "��ǰ��ȣ : "
													+ JSONData.prodNo
													+ "<br/>"
													+ "��� : "
													+ JSONData.stock
													+ "<br/>"
													+ "��ǰ�̹��� : <img src=/images/uploadFiles/"+ JSONData.fileName+ "/><br/>"
											"</h3>";

											//alert(displayValue);
											$("h3").remove();
											$("#" + prodNo + "").html(
													displayValue);
										}
									});
						});

		$("td:nth-child(4)").on(
				"click",
				function() {
					var prodNo = $(this).children("input").val();
					self.location = "/product/getProduct?prodNo=" + prodNo
							+ "&menu=${param.menu}";
				});

		$("h8:contains('����ϱ�')")
				.on(
						"click",
						function() {
							//alert($("#prodNo").val());
							self.location = "/purchase/updateTranCodeByProd?menu=manage&prodNo="
									+ $("#prodNo").val() + "&tranCode=2";
						});

		$(".ct_list_pop td:nth-child(3)").css("color", "#DF7401");
		$(".ct_list_pop td:nth-child(1)").css("color", "#DBA901");
		$("h8").css("color", "#FE642E");
		$(".ct_list_pop td:nth-child(9):contains('ǰ��')")
				.css("color", "#FF0040");

		$(".ct_list_pop:nth-child(4n+6)").css("background-color", "whitesmoke");

	});
</script>
</head>

<body>
	<!-- ToolBar Start /////////////////////////////////////-->
	<jsp:include page="/layout/toolbar.jsp" />
	<!-- ToolBar End /////////////////////////////////////-->
	<div class="container">

		<div class="page-header text-info">
			<!--manage�� ��� ��ǰ���� search�ΰ�� ��ǰ�����ȸ -->
			<c:if test="${param.menu=='manage'}">
						��ǰ����
					</c:if>
			<c:if test="${param.menu=='search'}">
						��ǰ �����ȸ
					</c:if>
		</div>

		<div class="row">

			<div class="col-md-6 text-left">
				<p class="text-primary">��ü ${resultPage.totalCount } �Ǽ�, ����
					${resultPage.currentPage} ������</p>
			</div>

			<div class="col-md-6 text-right">

				<form class="form-inline" name="detailForm">

					<div class="form-group">
						<select class="form-control" name="searchCondition">
							<option value="0"
								${ ! empty search.searchCondition && search.searchCondition==0 ? "selected" : "" }>��ǰ��ȣ</option>
							<option value="1"
								${ ! empty search.searchCondition && search.searchCondition==1 ? "selected" : "" }>��ǰ��</option>
							<option value="2"
								${ ! empty search.searchCondition && search.searchCondition==2 ? "selected" : "" }>��ǰ����</option>
						</select>
					</div>

					<div class="form-group">
						<label class="sr-only" for="searchKeyword">�˻���</label> <input
							type="text" class="form-control" id="searchKeyword"
							name="searchKeyword" placeholder="�˻���"
							value="${! empty search.searchKeyword ? search.searchKeyword : '' }">
					</div>

					<button type="button" class="btn btn-default">�˻�</button>

					<!-- PageNavigation ���� ������ ���� ������ �κ� -->
					<input type="hidden" id="currentPage" name="currentPage" value="" />

				</form>
			</div>

		</div>



		<table class="table table-hover table-striped">
			<thead>
				<tr>
					<th align="center">No</th>
					<th align="left">��ǰ�� (click:��������)</th>
					<th align="left">����</th>
					<th align="left">��ǰ������(click:������)</th>
					<th align="left">�������</th>

				</tr>
			</thead>
			<tbody>

				<c:set var="i" value="0" />
				<c:forEach var="product" items="${list}">
					<c:set var="i" value="${i+1 }" />
					
						<div class="col-sm-6 col-md-4">
							<div class="thumbnail">
								<img src="/images/uploadFiles/${product.fileName}" width ="200px" height="200px" >
								<div class="caption">
									<h3> ${product.prodName }</h3>
									<p>...</p>
									<p>
										<a href="#" class="btn btn-primary" role="button">Button</a> <a
											href="#" class="btn btn-default" role="button">Button</a>
									</p>
								</div>
							</div>
					
					</div>
					<c:set var="i" value="${i+1 }" />
					<tr>
						<td align="center"><input type="hidden" name="prodNo"
							value="${product.prodNo }">${i }</td>
						<td align="left"><input type="hidden" name="prodNo"
							value="${product.prodNo }"> ${product.prodName }</td>
						<td align="left">${product.price }��</td>
						<td align="left"><input type="hidden" name="prodNo"
							value="${product.prodNo }">${product.prodDetail }</td>
						<td align="left"><c:if test="${product.stock!=0 }">�Ǹ���</c:if>
							<c:if
								test="${product.stock==0 && (empty user ||  empty product.proTranCode || !empty user)}">
							ǰ��</c:if></td>
					</tr>
					<tr>
						<td id="${product.prodNo}" colspan="11" bgcolor="D6D7D6"
							height="1"></td>
					</tr>
				</c:forEach>
			</tbody>
		</table>

	</div>
	<!--  ȭ�鱸�� div End /////////////////////////////////////-->


	<!-- PageNavigation Start... -->
	<jsp:include page="../common/pageNavigator_new.jsp" />
	<!-- PageNavigation End... -->

</body>
</html>
