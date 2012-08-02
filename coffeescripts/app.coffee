#$('#coverOverlay').show()
#$('#statusContainer').hide()
#$('#newAlbum').show()

$('#loginOverlay').show()

$('.closeOverlay').click ->
  $(@).parent('.overlay').hide()

navTop = $('.stepMessage').position().top
tmpStepMessage = $('#instruction2')

$(window).scroll ->
  curtop = $(window).scrollTop()
  if (curtop >= navTop)
    tmpStepMessage.show()
    $('#instruction').css('opacity', 0)
  else
    tmpStepMessage.hide()
    $('#instruction').css('opacity', 1)

drop = (evt) ->
  $('#statusContainer').hide()
  evt.stopPropagation()
  evt.preventDefault()
  
  if $('.selectedAlbum').length > 0
    $('#progressBar').show()
    files = evt.dataTransfer.files
    url = "https://graph.facebook.com/"+$('.selectedAlbum').attr('id')+"/photos"
    for file in files
      formData = new FormData()
      formData.append('access_token', window.fbAccessToken)
      formData.append(file.name, file)
      
      xhr = new XMLHttpRequest()
      xhr.open("POST", url, true)
      
      xhr.send(formData)
  else
    $('#newAlbum').show()
    files = evt.dataTransfer.files
    for file in files
      newDiv = $('<div />', {class:"fileAdd"})
      newDiv.text(file.name)
      $('#albumFilesContainer').append(newDiv)
    
## init event handlers
prevent = (evt) ->
  evt.stopPropagation()
  evt.preventDefault()
  
dragEnter = (evt) ->
  evt.stopPropagation()
  evt.preventDefault()
  $('#coverOverlay').show()
  numEnter += 1

dragLeave = (evt) ->
  evt.stopPropagation()
  evt.preventDefault()
  numEnter -= 1
  if (numEnter == 0)
    $('#coverOverlay').hide()
  
reset = (evt) ->
  evt.stopPropagation()
  evt.preventDefault()
  $('#coverOverlay').hide()
  numEnter = 0
  
numEnter = 0
document.addEventListener("dragenter", dragEnter, false)
document.addEventListener("dragleave", dragLeave, false)
document.addEventListener("dragend", reset, false)
document.addEventListener("dragover", prevent, false)
document.addEventListener("drop", drop, false)

getAlbums = (response) ->
  for album in response.data
    newDiv = $('<div />', {class:'albumImg', coverPhoto:album.cover_photo, id:album.id, name:album.name })
    newa = $('<span />', {href:'#', class:'thumbnail'})
    newp = $('<p />', {text:album.name})
    newImg = $('<img />', {src:"http://placehold.it/360x180"})
    newa.append(newp)
    newa.append(newImg)
    newDiv.append(newa)
    $('#albumStep').append(newDiv)
    newDiv.click ->
      if $(@).hasClass('selectedAlbum')
        $('.selectedAlbum').removeClass('selectedAlbum')
        $('.stepMessage').text("Drag Pictures in here to create new Album!")
      else
        $('.selectedAlbum').removeClass('selectedAlbum')
        $(this).addClass('selectedAlbum')
        $('.stepMessage').text("Drag Pictures into #{$(this).attr('name')}")
    
    FB.api "/"+album.cover_photo, (response2) ->
      img = $('.albumImg[coverPhoto='+response2.id+"]").find('img')
      img.attr('src', response2.source)

$('#createAlbum').click ->
  FB.api '/me/albums', 'post', {name:'testAlbum', description:'Album is created as a test from the HACK FOR CHANGE'}, (response) ->
  
$('#fbloginButton').click ->
  FB.login (response) ->
    if (response.authResponse)
      $('#fblogout').show()
      $('#loginOverlay').hide()
      $('.container').show()
    else
      alert("Please Allow")
  , {scope: 'user_photos,friends_photos,publish_stream'}

$('#fblogout').click ->
  FB.logout ->
    $('#loginOverlay').show()
    $('#fblogout').hide()
    $('.albumImg').remove()
    $('.container').hide()

window.fbAsyncInit = ->
  FB.init
    appId      : '132631233489866'
    status     : true
    cookie     : true
    xfbml      : true

  FB.getLoginStatus (response) ->
    if (response.status!="connected")
      $('#fblogin').show()
      $('#fblogout').hide()
    else
      window.fbAccessToken=response.authResponse.accessToken
      FB.api '/me/albums', getAlbums
      $('#loginOverlay').hide()
      $('#fblogout').show()
      $('#fblogin').hide()

  FB.Event.subscribe 'auth.statusChange', (response) ->
    console.log("status changes")
    if (response.status!="connected")
      $('#fblogin').show()
      $('#fblogout').hide()
    else
      window.fbAccessToken=response.authResponse.accessToken
      FB.api '/me/albums', getAlbums
      $('#fblogout').show()
      $('#fblogin').hide()
      
temp = (d) ->
  js = ""
  id = 'facebook-jssdk'
  ref = d.getElementsByTagName('script')[0]
  if (d.getElementById(id))
    return
  js = d.createElement('script')
  js.id = id
  js.async = true
  js.src = "//connect.facebook.net/en_US/all.js"
  ref.parentNode.insertBefore(js, ref)
  "success"

temp(document)
