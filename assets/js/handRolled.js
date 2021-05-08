export default {
  mounted() {
    console.log("mounted");
    console.log("window height:", windowHeight());
    // height of top section
    const topHeight = getElementHeight("top-section");
    const tableHeaderHeight = getElementHeight("table-header");
    const winHeight = windowHeight();

    const tableHeight = winHeight - topHeight - tableHeaderHeight;
    console.log("table height: ", tableHeight);
    console.log(
      "height balance:",
      winHeight - topHeight - tableHeaderHeight - tableHeight
    );

    // setHeight("table-rows", tableHeight);
  },
  updated() {
    console.log("updated");
  },
};

function getElementHeight(id) {
  const elem = document.querySelector("#" + id);
  if (elem) {
    const rect = elem.getBoundingClientRect();
    console.log(`${id} height: `, rect.height);
    return rect.height;
  }
  return 0;
}

function windowHeight() {
  return (
    window.innerHeight ||
    document.documentElement.clientHeight ||
    document.body.clientHeight
  );
}

function setHeight(id, height) {
  const elem = document.querySelector("#" + id);
  if (elem) {
    elem.style.height = height + "px";
  }
}
