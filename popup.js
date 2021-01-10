// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

'use strict';

let changeColor = document.getElementById('cutCookie');

chrome.storage.sync.get('color', function(data) {
  changeColor.style.backgroundColor = data.color;
  changeColor.setAttribute('value', data.color);
});

changeColor.onclick = function(element) {
  let color = element.target.value;
  // let bgColour = document.body.style.backgroundColor;

  chrome.tabs.query({active: true, currentWindow: true}, function(tabs) {
    // if (bgColour == color) {
    //   chrome.tabs.executeScript(
    //     tabs[0].id,
    //     {code: 'document.body.style.backgroundColor = "#fff";'});
    // }
    // else {
    chrome.tabs.executeScript(
      tabs[0].id,
      {code: 'document.body.style.backgroundColor = "' + color + '";'});
    // }
  });
};






let cookieJar = document.getElementById('cookieJar');
let options = document.getElementById('options');


function focusOrCreateTab(url) {
  chrome.windows.getAll({"populate":true}, function(windows) {
    var existing_tab = null;
    for (var i in windows) {
      var tabs = windows[i].tabs;
      for (var j in tabs) {
        var tab = tabs[j];
        if (tab.url == url) {
          existing_tab = tab;
          break;
        }
      }
    }
    if (existing_tab) {
      chrome.tabs.update(existing_tab.id, {"selected":true});
    } else {
      chrome.tabs.create({"url":url, "selected":true});
    }
  });
}

cookieJar.onclick = function(element)  {
  var manager_url = chrome.extension.getURL("cookiejar.html");
  focusOrCreateTab(manager_url);
};

options.onclick = function(element)  {
  var options_url = chrome.extension.getURL("options.html");
  focusOrCreateTab(options_url);
};
