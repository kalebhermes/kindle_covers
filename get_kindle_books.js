var db = openDatabase('K4W', '3', 'thedatabase', 1024 * 1024);

getAmazonCsv = function() {
  var asinList = "";

  db.transaction(function(tx) {
    tx.executeSql('SELECT * FROM bookdata;', [], function(tx, results) {
      var len = results.rows.length;

      for (i = 1; i < len; i++) {
        var asin = results.rows.item(i).asin;
        asinList = asinList + asin + ",";
      }

      var textArea = document.createElement("textarea");
      textArea.value = asinList;
      
      // Avoid scrolling to bottom
      textArea.style.top = "0";
      textArea.style.left = "0";
      textArea.style.position = "fixed";
    
      document.body.appendChild(textArea);
      textArea.focus();
      textArea.select();
    
      try {
        var successful = document.execCommand('copy');
        console.log(asinList);
        console.log("List was copied to the clipboard. Return to https://kindlecovers.com and paste there!");
      } catch (err) {
        console.error('Oops, unable to copy, check https://github.com/kalebhermes/kindle_covers/issues for help!', err);
      }
    
      document.body.removeChild(textArea);
    });
  });
};

getAmazonCsv();