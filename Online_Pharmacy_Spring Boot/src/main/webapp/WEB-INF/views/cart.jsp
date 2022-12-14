
<%@page import="com.pharmacy.model.DistributorItemBean"%>
<%@page import="com.pharmacy.service.DistributorItemService"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="ISO-8859-1">
<title>Online Pharmacy</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/assets/itemslist.component.css">
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css?family=Tangerine">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://fonts.googleapis.com/css2?family=Material+Icons+Outlined"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
	integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo"
	crossorigin="anonymous"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/5.0.0-alpha1/js/bootstrap.min.js"
	integrity="sha384-oesi62hOLfzrys4LxRF63OJCXdXDipiYWBnvTl9Y9/TRlw5xlKIEHpNyvvDShgf/"
	crossorigin="anonymous"></script>
</head>
<style>
body{
  background-image: url('https://media.istockphoto.com/photos/trolley-with-pills-on-a-blue-background-concept-cost-of-medicines-picture-id1019862372?k=20&m=1019862372&s=612x612&w=0&h=WttgaZaXa4p3QR6WCScRGUHKYq9PGgcOjFZg40gjuRU=');
  background-size: 1300px 650px;
  background-repeat: no-repeat;
}
</style>
<body>
	<%
	response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
	response.setHeader("Pragma", "no-cache");
	response.setHeader("Expires", "0");
	String token = (String) session.getAttribute("token");
	if (session.getAttribute("username") == null || !token.contains("USER")) {
		response.sendRedirect("login");
	} else {
		double total = 0.0;
	%>
	<%@include file="navbar.jsp"%>
	<div class="container">
		<div class="d-flex justify-content-center">
			<div class="card shadow rounded" id="cart-card" style="width: 100%">
				<h3 class="card-header text-primary"
					style="text-align: center; font-weight: bold;">Your cart</h3>
				<div class="card-body">
					<p class="text-center text-secondary  mt-2 mb-4 heading">
						<u>Items in the cart will be removed when you logout!</u>
					</p>
					<div class="row">
						<div class="col-8">
							<%
							ArrayList<DistributorItemBean> list = (ArrayList<DistributorItemBean>) session.getAttribute("cartList");
							if (list != null) {
								for (DistributorItemBean cart : list) {
									total += cart.getPrice();
							%>

							<form action="${pageContext.request.contextPath}/updatecart"
								method="POST">
								<div class="row">
									<div class="col-8">
										<div class="content">
											<h5 class="h5 text-primary"><%=cart.getItemName()%></h5>
											<p class="text-secondary fw-bold">Description:</p>
											<span><%=cart.getDescription()%></span><br>
										</div>
									</div>
									<div class="col-4">
										<div class="row">
											<div class="col-6">
												<label for="quantity fs-5">Quantity:</label> <input
													id="quantity" name="quantity" type="number"
													value="<%=cart.getQuantity()%>"
													max="<%=cart.getQuantity()%>"
													class="form-control quantity-input">

											</div>
											<div class="col-6 mt-4">
												<span class="fs-5"><%=cart.getPrice()%></span>
											</div>
										</div>
									</div>
								</div>
								<br> <br>
								<%
								}
								%>

								<div class="form-check form-check-inline ms-3">
									<input type="radio" class="form-check-input" name="checkbox"
										id="update" value="update" checked /> <label
										class="form-check-label" for="update"> Update List </label>
								</div>
								<div class="form-check form-check-inline">
									<input type="radio" class="form-check-input" name="checkbox"
										value="checkout" id="checkout" /> <label
										class="form-check-label" for="checkout"> Checkout </label>
								</div>
								<div class="form-check form-check-inline">
									<input type="radio" class="form-check-input" name="checkbox"
										value="clear" id="clear" /> <label class="form-check-label"
										for="clear"> Clear </label>
								</div>
								<br> <br>
								<button type="submit" class="btn btn-primary col-11 ms-3">
									Proceed</button>
							</form>
						</div>

						<div class="col-4 bg-light">
							<p class="text-center text-primary h3">Order Summary</p>
							<br>
							<div>
								<p class="h5 float-start">Subtotal:</p>
								<span class="text-muted float-end fs-5">Rs.<%=total%></span><br>
								<hr>
								<p class="h5 float-start">Discount:</p>
								<span class="text-muted float-end fs-5">Rs.0</span><br>
								<hr>
								<p class="h5 float-start">Total:</p>
								<span class="text-muted float-end fs-5">Rs.<%=total%></span>

							</div>
						</div>
						<%
						} else {
						%>
					</div>
					<div
						class="alert alert-danger text-center position-relative top-50 start-50 translate-middle w-75 mt-5"
						role="alert">Your Cart is Empty!</div>

					<%
					}
					%>

				</div>
			</div>
		</div>
	</div>
	<%
	}
	%>
</body>
</html>