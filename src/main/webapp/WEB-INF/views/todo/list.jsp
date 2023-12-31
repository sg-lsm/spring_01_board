<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!doctype html>
<html lang="kr">
<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

    <title>List</title>
</head>
<body>
    <h1>List</h1>
    <div class="container-fluid">

        <div class="row">
            <nav class="navbar navbar-expand-lg navbar-light bg-light">
                <div class="container-fluid">
                    <a class="navbar-brand" href="#">Navbar</a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarSupportedContent">
                        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                            <li class="nav-item">
                                <a class="nav-link active" aria-current="page" href="#">Home</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">Link</a>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    Dropdown
                                </a>
                                <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                                    <li><a class="dropdown-item" href="#">Action</a></li>
                                    <li><a class="dropdown-item" href="#">Another action</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="#">Something else here</a></li>
                                </ul>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link disabled" href="#" tabindex="-1" aria-disabled="true">Disabled</a>
                            </li>
                        </ul>
                        <form class="d-flex">
                            <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
                            <button class="btn btn-outline-success" type="submit">Search</button>
                        </form>
                    </div>
                </div>
            </nav>
        </div>

        <div class="row content">
            <div class="col">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Search</h5>
                        <form action="/todo/list" method="get">
                            <input type="hidden" name="size" value="${pageRequestDTO.size}" />
                            <div class="mb-3">
                                <input type="checkbox" name="finished" /> 완료여부
                            </div>
                            <div class="mb-3">
                                <input type="checkbox" name="types" value="t" ${pageRequestDTO.checkType("t") ? "checked" : "" } /> 제목
                                <input type="checkbox" name="types" value="w" ${pageRequestDTO.checkType("w") ? "checked" : "" }/> 작성자
                                <input type="text" name="keyword" class="form-control" value='<c:out value="${pageRequestDTO.keyword}" />' />
                            </div>
                            <div class="input-group mb-3 localDateDiv">
                                <input type="date" name="from" class="form-control" value="${pageRequestDTO.from}" />
                                <input type="date" name="to" class="form-control" value="${pageRequestDTO.to}" />
                            </div>
                            <div class="input-group mb-3">
                                <div class="float-end">
                                    <button class="btn btn-primary" type="submit">Button</button>
                                    <button class="btn btn-info clearBtn" type="reset">Clear</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>


        <div class="row content">
            <div class="col">
                <div class="card" >
                    <div class="card-body">
                        <h5 class="card-title">special title treatment</h5>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th score="col">Tno</th>
                                    <th score="col">Title</th>
                                    <th score="col">Writer</th>
                                    <th score="col">LocalDate</th>
                                    <th score="col">Finished</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${resDTO.dtoList}" var="dto">
                                <tr>
                                    <th score="row"><c:out value="${dto.tno}" /></th>
                                    <td><a href="/todo/read?tno=${dto.tno}&${pageRequestDTO.link}" class="text-decoration-none" data-tno="${dto.tno}"><c:out value="${dto.title}" /> </a></td>
                                    <td><c:out value="${dto.writer}" /></td>
                                    <td><c:out value="${dto.localDate}" /></td>
                                    <td><c:out value="${dto.finished}" /></td>
                                </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <div class="float-end">
                            <ul class="pagination flex-wrap">

                                <c:if test="${resDTO.prev}">
                                    <li class="page-item">
                                        <a class="page-link" data-num="${resDTO.start -1}">Previous</a>
                                    </li>
                                </c:if>

                                <c:forEach begin="${resDTO.start}" end="${resDTO.end}" var="num">
                                    <li class = "page-item ${resDTO.page == num ? "active" : ""}" >
                                        <a class="page-link" data-num="${num}">${num}</a>
                                    </li>
                                </c:forEach>

                                <c:if test="${resDTO.next}">
                                    <li class="page-item">
                                        <a class="page-link" data-num="${resDTO.end +1}">Next</a>
                                    </li>
                                </c:if>
                            </ul>
                        </div>
                    <script>

                        document.querySelector(".pagination").addEventListener("click", function (e) {
                            e.preventDefault()
                            e.stopPropagation()

                            const target = e.target

                            if(target.tagName !== 'A'){
                                return
                            }

                            const num = target.getAttribute("data-num")

                            self.location = `/todo/list?page=\${num}`
                       }, false)


                        document.querySelector(".clearBtn").addEventListener("click", function(e){
                            e.preventDefault()
                            e.stopPropagation()

                            self.location = '/todo/list'

                        },false)

                        document.querySelector(".pagination").addEventListener("click", function(e){
                            e.preventDefault()
                            e.stopPropagation()

                            const target = e.target

                            if(target.tagName !== 'A'){
                                return
                            }

                            const num = target.getAttribute("data-num")
                            const formObj = document.querySelector("form")
                            formObj.innerHtml += `<input type='hidden' name='page' value='\${num}' />`
                            formObj.submit()
                        }, false)

                    </script>


                    </div>
                </div>
            </div>
        </div>
        <div class="row footer">
            <div class="row fixed-bottom" style="z-index: -100">
                <footer class="py-1 my-1">
                    <p class="text-center text-muted">Footer</p>
                </footer>
            </div>
        </div>
    </div>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>

</body>
</html>