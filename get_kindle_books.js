// init
let xhr = new XMLHttpRequest();
let domain = "https://read.amazon.com/";
let items = [];
let csvData = "";

// function
function getItemsList(paginationToken = null) {
  let url =
    domain +
    "kindle-library/search?query=&libraryType=BOOKS" +
    (paginationToken ? "&paginationToken=" + paginationToken : "") +
    "&sortType=acquisition_desc&querySize=50";
  xhr.open("GET", url, false);
  xhr.send();
}

// request result
xhr.onreadystatechange = function () {
  switch (xhr.readyState) {
    case 0:
      console.log("uninitialized");
      break;
    case 1:
      console.log("loading...");
      break;
    case 4:
      if (xhr.status == 200) {
        let data = xhr.responseText;
        data = JSON.parse(data);
        if (data.itemsList) {
          items.push(...data.itemsList);
        }
        if (data.paginationToken) {
          getItemsList(data.paginationToken);
        } else {
          console.log(items.map((item) => item.asin).join(","));
        }
      } else {
        console.log("Failed");
      }
      break;
  }
};

getItemsList();
