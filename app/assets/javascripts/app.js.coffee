BookApp = angular.module("BookApp", [])


BookApp.controller("BooksCtrl", ["$scope", "$http", ($scope, $http)->
  console.log "inside controller"
  $scope.books = []

  $http.get("/books.json").success (data) ->
    $scope.books = data

  $scope.addBook = ->
    console.log "add book button"
    console.log $scope.newBook
    $http.post("/books.json", $scope.newBook).success (data)->
      console.log "book added!"
      $scope.newBook = {}
      $scope.books.push(data) #adds new book to books array to display on page
    
  $scope.editBook = ->
    $http.put("/books/#{@book.id}.json", @book).success (data)=>
      console.log "Book is edited!"

  $scope.deleteBook = ->
    console.log "delete pushed"
    console.log @book # @book==this.book (you can use either)
    $http.delete("/books/#{@book.id}.json").success (data) => #same as "/books/"+@book.id+".json"
      console.log "book deleted"
      $scope.books.splice(this.$index, 1)
])


# below code is needed to get around security tokens to create/update/destroy books
BookApp.config(["$httpProvider", ($httpProvider)->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token').attr('content')
])