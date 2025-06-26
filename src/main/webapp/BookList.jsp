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
<body>
    <div class="container">
        <div align="center">
            <h1>Books Management</h1>
            <h2>
                <c:url value="/new" var="newUrl" />
                <c:url value="/list" var="listUrl" />
                <a href="${newUrl}">Add New Book</a> &nbsp;&nbsp;&nbsp; <a href="${listUrl}">List All Books</a>
            </h2>
        </div>
	
		<div align="center">
            <!-- <table border="1" cellpadding="5"> -->
            <table class="pure-table pure-table-striped">
                <caption>List of Books</caption>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Author</th>
                    <th>Price</th>
                    <th>Actions</th>
                </tr>
                </thead>

                <tbody>
                <c:url value="/edit" var="editUrl" />
			    <c:url value="/delete" var="deleteUrl" />
                <c:forEach var="book" items="${listBook}">
                    <tr>
                        <td><c:out value="${book.id}" /></td>
                        <td><c:out value="${book.title}" /></td>
                        <td><c:out value="${book.author}" /></td>
                        <td align="right" ><c:out value="${book.price}" /></td>
                        <td><a href="${editUrl}?id=<c:out value='${book.id}' />">Edit</a>
                            &nbsp;&nbsp;&nbsp;&nbsp; <a
                            href="${deleteUrl}?id=<c:out value='${book.id}' />">Delete</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
    	</div>
	</div>
	
</body>
</html>