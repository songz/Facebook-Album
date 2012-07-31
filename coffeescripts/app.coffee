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
  $('#coverOverlay').hide()
  evt.stopPropagation()
  evt.preventDefault()
  
  files = evt.dataTransfer.files
  url = "https://graph.facebook.com"+$('.selectAlbum').attr('id')+"/photos";
  for file in files
    formData = new FormData()
    formData.append('access_token', window.fbAccessToken)
    formData.append(file.name, file)
    
    xhr = new XMLHttpRequest()
    xhr.open("POST", url, true)
    
    xhr.send(formData)
    
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
  evt.stopPropagation();
  evt.preventDefault();
  numEnter -= 1;
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
    newDiv = $('<div />', {class:'albumImg', coverPhoto:album.cover_photo, id:album.id })
    newa = $('<span />', {href:'#', class:'thumbnail'})
    newp = $('<p />', {text:album.name})
    newImg = $('<img />', {src:"http://placehold.it/360x180"})
    newa.append(newp)
    newa.append(newImg)
    newDiv.append(newa)
    $('#albumStep').append(newDiv)
    newDiv.click ->
      $('.selectedAlbum').removeClass('selectedAlbum')
      $(this).addClass('selectedAlbum')
      $('#instruction').text('Drag Pictures here!')
    
    FB.api "/"+album.cover_photo, (response2) ->
      img = $('.albumImg[coverPhoto='+response2.id+"]").find('img')
      img.attr('src', response2.source)

$('#createAlbum').click ->
  FB.api '/me/albums', 'post', {name:'testAlbum', description:'Album is created as a test from the HACK FOR CHANGE'}, (response) ->
  
$('#fblogout').click ->
  FB.logout ->
    $('#fblogin').show()
    $('#fblogout').hide()
    
$('#fblogin').click ->
  FB.login (response) ->
    if (response.authResponse)
      $('#fblogout').show()
      $('#fblogin').hide()
    else
      alert("Please Allow")
  , {scope: 'publish_stream'}

window.fbAsyncInit = ->
  FB.init
    appId      : '132631233489866'
    status     : true
    cookie     : true
    xfbml      : true

    FB.Event.subscribe 'auth.statusChange', (response) ->
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