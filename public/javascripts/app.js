// Generated by CoffeeScript 1.3.3
(function() {
  var PictureFile, dragEnter, dragLeave, drop, getAlbums, navTop, newAlbumFiles, numEnter, prevent, reset, temp, tmpStepMessage, uploadPics,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  $('#emailForm').hide();

  $('#donateButton').click(function() {
    return $('#donationOverlay').show();
  });

  $('#getEmails').click(function() {
    var newLeft;
    newLeft = $('#caret').position().left - 150 + 'px';
    $('#emailForm').css({
      left: newLeft
    });
    if ($('#emailForm').is(":visible")) {
      return $('#emailForm').slideUp('fast');
    } else {
      return $('#emailForm').slideDown('fast', function() {
        return $('#name').focus();
      });
    }
  });

  window.onresize = function() {
    return $('#emailForm').hide();
  };

  $('.closeOverlay').click(function() {
    return $(this).parent('.overlay').hide();
  });

  navTop = $('.stepMessage').position().top;

  tmpStepMessage = $('#instruction2');

  $(window).scroll(function() {
    var curtop;
    curtop = $(window).scrollTop();
    if (curtop >= navTop) {
      tmpStepMessage.show();
      return $('#instruction').css('opacity', 0);
    } else {
      tmpStepMessage.hide();
      return $('#instruction').css('opacity', 1);
    }
  });

  PictureFile = (function() {

    function PictureFile(fileId) {
      this.fileId = fileId;
      this.progressFunction = __bind(this.progressFunction, this);

      console.log(this.fileId);
    }

    PictureFile.prototype.progressFunction = function(evt) {
      var curr, total, upload;
      curr = evt.loaded;
      total = evt.totalSize;
      upload = (curr / total) * 100;
      console.log(this.fileId);
      if (upload === 100) {
        $("#row" + this.fileId).remove();
        if ($('.bar').length === 0) {
          $('.stepMessage').text("Done. Drag More Pictures in here to create new Album!");
          $('.selectedAlbum').removeClass('selectedAlbum');
          return $('#coverOverlay').hide();
        }
      } else {
        return $("#" + this.fileId).attr('style', 'width: ' + upload + "%; height:100%");
      }
    };

    return PictureFile;

  })();

  $('#createAlbumButton').click(function() {
    var albumDescription, albumName;
    albumName = $('#albumName').val();
    albumDescription = $('#albumDescription').val();
    return FB.api('/me/albums', 'post', {
      name: albumName,
      message: albumDescription
    }, function(response) {
      var albumId, newDiv, newImg, newa, newp;
      albumId = response.id;
      uploadPics(newAlbumFiles, albumId);
      newDiv = $('<div />', {
        "class": 'albumImg',
        coverPhoto: "ag",
        id: albumId,
        name: albumName
      });
      newa = $('<span />', {
        href: '#',
        "class": 'thumbnail'
      });
      newp = $('<p />', {
        text: albumName
      });
      newImg = $('<img />', {
        src: "http://placehold.it/360x180"
      });
      newa.append(newp);
      newa.append(newImg);
      newDiv.append(newa);
      $('#albumStep').prepend(newDiv);
      return newDiv.click(function() {
        if ($(this).hasClass('selectedAlbum')) {
          $('.selectedAlbum').removeClass('selectedAlbum');
          return $('.stepMessage').text("Drag Pictures in here to create new Album!");
        } else {
          $('.selectedAlbum').removeClass('selectedAlbum');
          $(this).addClass('selectedAlbum');
          return $('.stepMessage').text("Drag Pictures into " + ($(this).attr('name')));
        }
      });
    });
  });

  uploadPics = function(files, albumId) {
    var file, fileId, formData, html, i, picture, url, xhr, _i, _len, _results;
    $('#statusContainer').hide();
    $('#newAlbum').hide();
    $('#progressBar').show();
    if (albumId != null) {
      url = "https://graph.facebook.com/" + albumId + "/photos";
    } else {
      url = "https://graph.facebook.com/" + $('.selectedAlbum').attr('id') + "/photos";
    }
    i = 0;
    _results = [];
    for (_i = 0, _len = files.length; _i < _len; _i++) {
      file = files[_i];
      fileId = 'file' + i;
      i += 1;
      html = "<tr id=\"row" + fileId + "\">\n  <td><div class=\"filename\">" + file.name + "</div></td>\n  <td class=\"statsProgress\">\n  <div class=\"progress progress-striped active\">\n    <div id=\"" + fileId + "\" class=\"bar\" style=\"width: 0%; height: 100%\"></div>\n  </div>\n  </td>\n</tr>";
      $('#statusTable').append(html);
      formData = new FormData();
      formData.append('access_token', window.fbAccessToken);
      formData.append(file.name, file);
      picture = new PictureFile(fileId);
      xhr = new XMLHttpRequest();
      xhr.upload.addEventListener("progress", picture.progressFunction, false);
      xhr.open("POST", url, true);
      _results.push(xhr.send(formData));
    }
    return _results;
  };

  newAlbumFiles = [];

  drop = function(evt) {
    var file, newDiv, _i, _len, _results;
    newAlbumFiles = [];
    $('#statusContainer').hide();
    evt.stopPropagation();
    evt.preventDefault();
    if ($('.selectedAlbum').length > 0) {
      return uploadPics(evt.dataTransfer.files);
    } else {
      $('#progressBar').hide();
      $('#newAlbum').show();
      newAlbumFiles = evt.dataTransfer.files;
      _results = [];
      for (_i = 0, _len = newAlbumFiles.length; _i < _len; _i++) {
        file = newAlbumFiles[_i];
        newDiv = $('<div />', {
          "class": "fileAdd"
        });
        newDiv.text(file.name);
        _results.push($('#albumFilesContainer').append(newDiv));
      }
      return _results;
    }
  };

  prevent = function(evt) {
    evt.stopPropagation();
    return evt.preventDefault();
  };

  dragEnter = function(evt) {
    evt.stopPropagation();
    evt.preventDefault();
    $('#coverOverlay').show();
    $('#statusContainer').show();
    $('#progressBar').hide();
    $('#newAlbum').hide();
    return numEnter += 1;
  };

  dragLeave = function(evt) {
    evt.stopPropagation();
    evt.preventDefault();
    numEnter -= 1;
    if (numEnter === 0) {
      return $('#coverOverlay').hide();
    }
  };

  reset = function(evt) {
    var numEnter;
    evt.stopPropagation();
    evt.preventDefault();
    $('#coverOverlay').hide();
    return numEnter = 0;
  };

  numEnter = 0;

  document.addEventListener("dragenter", dragEnter, false);

  document.addEventListener("dragleave", dragLeave, false);

  document.addEventListener("dragend", reset, false);

  document.addEventListener("dragover", prevent, false);

  document.addEventListener("drop", drop, false);

  getAlbums = function(response) {
    var album, newDiv, newImg, newa, newp, _i, _len, _ref, _results;
    _ref = response.data;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      album = _ref[_i];
      newDiv = $('<div />', {
        "class": 'albumImg',
        coverPhoto: album.cover_photo,
        id: album.id,
        name: album.name
      });
      newa = $('<span />', {
        href: '#',
        "class": 'thumbnail'
      });
      newp = $('<p />', {
        text: album.name
      });
      newImg = $('<img />', {
        src: "http://placehold.it/170x150"
      });
      newa.append(newp);
      newa.append(newImg);
      newDiv.append(newa);
      $('#albumStep').append(newDiv);
      newDiv.click(function() {
        if ($(this).hasClass('selectedAlbum')) {
          $('.selectedAlbum').removeClass('selectedAlbum');
          return $('.stepMessage').text("Drag Pictures in here to create new Album!");
        } else {
          $('.selectedAlbum').removeClass('selectedAlbum');
          $(this).addClass('selectedAlbum');
          return $('.stepMessage').text("Drag Pictures into " + ($(this).attr('name')));
        }
      });
      _results.push(FB.api("/" + album.cover_photo, function(response2) {
        var img;
        img = $('.albumImg[coverPhoto=' + response2.id + "]").find('img');
        return img.attr('src', response2.source);
      }));
    }
    return _results;
  };

  $('#createAlbum').click(function() {
    return FB.api('/me/albums', 'post', {
      name: 'testAlbum',
      description: 'Album is created as a test from the HACK FOR CHANGE'
    }, function(response) {});
  });

  $('#fbloginButton').click(function() {
    return FB.login(function(response) {
      if (response.authResponse) {
        window.fbAccessToken = response.authResponse.accessToken;
        FB.api('/me/albums', getAlbums);
        $('#fblogout').show();
        return $('.container').show();
      } else {
        return alert("Please Allow");
      }
    }, {
      scope: 'user_photos,friends_photos,publish_stream'
    });
  });

  $('#fblogout').click(function() {
    return FB.logout(function() {
      return window.location = '/login';
    });
  });

  window.fbAsyncInit = function() {
    FB.init({
      appId: '132631233489866',
      status: true,
      cookie: true,
      xfbml: true
    });
    FB.getLoginStatus(function(response) {
      if (response.status !== "connected") {
        return window.location = '/login';
      } else {
        window.fbAccessToken = response.authResponse.accessToken;
        FB.api('/me', function(response2) {
          return $('#goToFB').click(function() {
            return window.location.href = "http://facebook.com/" + response2.username + "/photos";
          });
        });
        FB.api('/me/albums', getAlbums);
        return $('#fblogout').show();
      }
    });
    return FB.Event.subscribe('auth.statusChange', function(response) {
      if (response.status !== "connected") {
        return windown.location = '/login';
      } else {
        return $('#fblogout').show();
      }
    });
  };

  temp = function(d) {
    var id, js, ref;
    js = "";
    id = 'facebook-jssdk';
    ref = d.getElementsByTagName('script')[0];
    if (d.getElementById(id)) {
      return;
    }
    js = d.createElement('script');
    js.id = id;
    js.async = true;
    js.src = "//connect.facebook.net/en_US/all.js";
    ref.parentNode.insertBefore(js, ref);
    return "success";
  };

  temp(document);

}).call(this);
