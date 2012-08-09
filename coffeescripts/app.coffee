$('#emailForm').hide()
$('#donateButton').click ->
  $('#donationOverlay').show()

$('#getEmails').click ->
  newLeft=$('#caret').position().left-150+'px'
  $('#emailForm').css({left:newLeft})
  if $('#emailForm').is(":visible")
    $('#emailForm').slideUp 'slow'
  else
    $('#emailForm').slideDown 'slow' , ->
      $('#name').focus()

window.onresize = ->
  $('#emailForm').hide()
  
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

class PictureFile
  constructor: (@fileId) ->
    console.log @fileId

  progressFunction: (evt)=>
    curr = evt.loaded
    total = evt.totalSize
    upload = (curr/total)*100
    console.log upload
    console.log @fileId
    if upload == 100
      $("#row#{@fileId}").remove()
      if $('.bar').length == 0
        $('.stepMessage').text("Done. Drag More Pictures in here to create new Album!")
        $('.selectedAlbum').removeClass('selectedAlbum')
        $('#coverOverlay').hide()
    else
      $("##{@fileId}").attr('style', 'width: '+upload+"%; height:100%")

$('#createAlbumButton').click ->
  albumName = $('#albumName').val()
  albumDescription = $('#albumDescription').val()
  FB.api '/me/albums', 'post', {name:albumName, message:albumDescription}, (response) ->
    albumId = response.id
    uploadPics( newAlbumFiles, albumId )
    newDiv = $('<div />', {class:'albumImg', coverPhoto:"ag", id:albumId, name:albumName })
    newa = $('<span />', {href:'#', class:'thumbnail'})
    newp = $('<p />', {text:albumName})
    newImg = $('<img />', {src:"http://placehold.it/360x180"})
    newa.append(newp)
    newa.append(newImg)
    newDiv.append(newa)
    $('#albumStep').prepend(newDiv)
    newDiv.click ->
      if $(@).hasClass('selectedAlbum')
        $('.selectedAlbum').removeClass('selectedAlbum')
        $('.stepMessage').text("Drag Pictures in here to create new Album!")
      else
        $('.selectedAlbum').removeClass('selectedAlbum')
        $(this).addClass('selectedAlbum')
        $('.stepMessage').text("Drag Pictures into #{$(this).attr('name')}")
    
uploadPics = (files, albumId) ->
  $('#statusContainer').hide()
  $('#newAlbum').hide()
  $('#progressBar').show()
  if albumId?
    url = "https://graph.facebook.com/"+albumId+"/photos"
  else
    url = "https://graph.facebook.com/"+$('.selectedAlbum').attr('id')+"/photos"
    #url = "/sendImage"
  i = 0
  for file in files
    fileId = 'file'+i
    i += 1
    html = """
            <tr id="row#{fileId}">
              <td><div class="filename">#{file.name}</div></td>
              <td class="statsProgress">
              <div class="progress progress-striped active">
                <div id="#{fileId}" class="bar" style="width: 0%; height: 100%"></div>
              </div>
              </td>
            </tr>
            """
    $('#statusTable').append(html)
    formData = new FormData()
    formData.append('access_token', window.fbAccessToken)
    formData.append(file.name, file)
    
    picture = new PictureFile( fileId )
    xhr = new XMLHttpRequest()
    xhr.upload.addEventListener("progress", picture.progressFunction, false)
    xhr.open("POST", url, true)
    xhr.send(formData)

newAlbumFiles = []

drop = (evt) ->
  newAlbumFiles = []
  $('#statusContainer').hide()
  evt.stopPropagation()
  evt.preventDefault()
  
  if $('.selectedAlbum').length > 0
    uploadPics( evt.dataTransfer.files )
  else
    $('#progressBar').hide()
    $('#newAlbum').show()
    newAlbumFiles = evt.dataTransfer.files
    for file in newAlbumFiles
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
  $('#statusContainer').show()
  $('#progressBar').hide()
  $('#newAlbum').hide()
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
    newImg = $('<img />', {src:"http://placehold.it/170x150"})
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
      window.fbAccessToken=response.authResponse.accessToken
      FB.api '/me/albums', getAlbums
      $('#fblogout').show()
      $('.container').show()
    else
      alert("Please Allow")
  , {scope: 'user_photos,friends_photos,publish_stream'}

$('#fblogout').click ->
  FB.logout ->
    window.location = '/login'

window.fbAsyncInit = ->
  FB.init
    appId      : '132631233489866'
    status     : true
    cookie     : true
    xfbml      : true

  FB.getLoginStatus (response) ->
    if (response.status!="connected")
      window.location = '/login'
    else
      window.fbAccessToken=response.authResponse.accessToken
      FB.api '/me', (response2) ->
        $('#goToFB').click ->
          window.location.href="http://facebook.com/#{response2.username}/photos"
      FB.api '/me/albums', getAlbums
      $('#fblogout').show()

  FB.Event.subscribe 'auth.statusChange', (response) ->
    console.log("status changes")
    if (response.status!="connected")
      windown.location='/login'
    else
      $('#fblogout').show()
      
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
