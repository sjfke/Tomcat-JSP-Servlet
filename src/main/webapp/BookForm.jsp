<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Books Store Application</title>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/purecss@3.0.0/build/pure-min.css" integrity="sha384-X38yfunGUhNzHpBaEBsWLO+A0HDYOQi8ufWDkZ0k9e0eXz/tH3II7uKZ9msv++Ls" crossorigin="anonymous">
</head>
<body background="/bookstore/images/Almost.png">

	<div align="center">
		<h1>Books Management</h1>
		<h2>
			<c:url value="/new" var="newUrl" />
			<c:url value="/list" var="listUrl" />
			<a href="${newUrl}">Add New Book</a> &nbsp;&nbsp;&nbsp; <a href="${listUrl}">List All Books</a>
		</h2>
	</div>

	<div align="center">
		<c:if test="${book != null}">
		    <c:set var="formAction" scope="page" value="update"/>
		    <c:set var="legend" scope="page" value="Edit Book"/>
		</c:if>
		<c:if test="${book == null}">
		    <c:set var="formAction" scope="page" value="insert"/>
		    <c:set var="legend" scope="page" value="Add New Book"/>
		</c:if>

        <form action="<c:out value="${formAction}"/>" method="post" class="pure-form pure-form-aligned">
            <fieldset>
                <legend><c:out value="${legend}"/></legend>
                <c:if test="${book != null}">
                    <input type="hidden" name="id" value="<c:out value='${book.id}' />" />
                </c:if>
                <div class="pure-control-group">
                    <label for="title">Title:</label>
                    <input id="title" name="title" type="text" value="<c:out value='${book.title}' />" placeholder="Title" size="45" />
                </div>
                <div class="pure-control-group">
                    <label for="author">Author:</label>
                    <input id="author" name="author" type="text" value="<c:out value='${book.author}' />" placeholder="Author" size="45" />
                </div>
                <div class="pure-control-group">
                    <label for="price">Price:</label>
                    <input id="price" name="price" type="text" placeholder="Price" value="<c:out value='${book.price}' />" size="5" />
                </div>
                <div class="pure-controls">
                    <button type="submit" class="pure-button pure-button-primary">Submit</button>
                </div>
            </fieldset>
        </form>
	</div>
</body>
</html>