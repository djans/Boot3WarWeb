<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta charset="utf-8">
    <link rel="shortcut icon" type="image/ico" href="http://www.datatables.net/favicon.ico">
    <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1.0, user-scalable=no">
    <title>DataTables example</title>
    <link rel="stylesheet" type="text/css" href="media/css/jquery.dataTables.css">
    <link rel="stylesheet" type="text/css" href="syntax/shCore.css">
    <link rel="stylesheet" type="text/css" href="demo.css">
    <style type="text/css" class="init"></style>
    <script type="text/javascript" language="javascript" src="https://code.jquery.com/jquery-3.5.1.js"></script>
    <script type="text/javascript" language="javascript" src="media/js/jquery.dataTables.js"></script>
    <script type="text/javascript" language="javascript" src="syntax/shCore.js"></script>
    <script type="text/javascript" language="javascript" src="demo.js"></script>
    <style>
        .divTable {
            width: 75%;
            margin-left: 10%;
            margin-right: 10%;
        }
    </style>

    <script type="text/javascript" language="javascript" class="init">
        var dataSet = ${books}
            $(document).ready(function () {
                $('#example').DataTable({
                    data: dataSet,
                    columns: [
                        {title: "id"},
                        {title: "Price"},
                        {title: "Name"}]
                });
            });
    </script>

</head>
<body class="dt-example">
<div class="divTable">
    <table id="example" class="display"></table>
    <form action="addBook" method="POST">
        <label for="id">ID:</label> <input type="text" name="id" id="id"/><br/>
        <label for="price">PRICE:</label><input type="number" name="price" id="price"/><br/>
        <label for="name">NAME:</label><input type="text" name="name" id="name"/><br/>
        <input type="submit" value="Submit" formaction="addBook">
    </form>
</div>
</body>
</html>