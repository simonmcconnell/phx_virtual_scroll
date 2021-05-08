import HyperList from "hyperlist";
import {
  getAttributeOrThrow,
  parseBoolean,
  parseInteger,
} from "./lib/attribute";
import { getLineHeight } from "./lib/utils";

/**
 * A hook used to render text lines as a virtual list,
 * so that only the visible lines are actually in the DOM.
 *
 * Configuration:
 *
 *   * `data-max-height` - the maximum height of the element, exceeding this height enables scrolling
 *
 *   * `data-follow` - whether to automatically scroll to the bottom as new lines appear
 *
 * The element should have two children:
 *
 *   * one annotated with `data-template` attribute, it should be hidden
 *     and contain all the line elements as its children
 *
 *   * one annotated with `data-content` where the visible elements are rendered,
 *     it should contain any styling relevant for the container
 */
const HyperlistLivebook = {
  mounted() {
    console.log("mounted");
    this.props = getProps(this);
    this.state = {
      // lineHeight: null,
      // templateElement: null,
      contentElement: null,
      virtualizedList: null,
      page: 1,
      fields: [],
      data: [],
    };

    // this.state.lineHeight = getLineHeight(this.el);

    // this.state.templateElement = this.el.querySelector("[data-template]");

    // if (!this.state.templateElement) {
    //   throw new Error(
    //     "VirtualizedLines must have a child with data-template attribute"
    //   );
    // }
    this.state.fieldsElement = this.el.querySelector("[data-fields]");
    this.state.fields = Array.from(this.state.fieldsElement.children || []).map(
      ({ dataset: { field } }) => {
        return field;
      }
    );

    console.log("fields", this.state.fields);

    if (!this.state.fieldsElement) {
      throw new Error(
        "VirtualizedLines must have a child with data-fields attribute"
      );
    }

    this.state.contentElement = this.el.querySelector("[data-content]");

    if (!this.state.contentElement) {
      throw new Error("VirtualizedLines must have a child with data-content");
    }

    // const response = fetch(
    //   this.props.url +
    //     "/api/events/page/" +
    //     this.state.page +
    //     "/page_size/" +
    //     this.props.pageSize
    // );

    this.pushEventTo(`#${this.el.id}`, "load-events", {page: this.state.page, page_size: this.props.pageSize});
    this.handleEvent(`receive-events-${this.state.page}`, (payload) =>
    {
      console.log('payload', payload);
      this.state.data = payload.events;
      
      const config = hyperListConfig(
        // this.state.templateElement,
        this.props.maxHeight,
        this.props.lineHeight,
        this.props.total,
        this
      );
      this.virtualizedList = new HyperList(this.state.contentElement, config);
    })

    // console.log("data", this.state.data);

    
  },

  updated() {
    console.log("updated");
    this.props = getProps(this);
    this.state.fields = Array.from(this.state.fieldsElement.children || []).map(
      ({ dataset: { field } }) => {
        return field;
      }
    );
    const config = hyperListConfig(
      // this.state.templateElement,
      this.props.maxHeight,
      this.props.lineHeight,
      this.props.total,
      this
    );

    console.log("fields", this.state.fields);

    const scrollTop = Math.round(this.state.contentElement.scrollTop);
    const maxScrollTop = Math.round(
      this.state.contentElement.scrollHeight -
        this.state.contentElement.clientHeight
    );
    const isAtTheEnd = scrollTop === maxScrollTop;

    this.virtualizedList.refresh(this.state.contentElement, config);

    if (this.props.follow && isAtTheEnd) {
      this.state.contentElement.scrollTop = this.state.contentElement.scrollHeight;
    }
  },
};

function hyperListConfig(
  // templateElement,
  maxHeight,
  lineHeight,
  total,
  hook
) {
  // const numberOfLines = templateElement.childElementCount;
  //  const numberOfLines = 100;

  return {
    height: Math.min(maxHeight, lineHeight * total),
    total: total,
    itemHeight: lineHeight,
    generate: (i) => {
      console.log("generate", i);

      // const response = await fetch(
      //     this.props.url +
      //       "/api/events/page/" +
      //       this.state.page +
      //       "/page_size/" +
      //       this.props.pageSize
      //   );

      const el = document.createElement("tr");
      // for each field, get it from object a position `i` in this.state.data
      const row = hook.state.fields.map((field) => {
        if (typeof hook.state.data[i] !== "undefined") {
          return hook.state.data[i][field];
        } else {
          return field;
        }
      });
      console.log("row", row);
      // el.append(`<td>${}</td>`)
      el.innerHTML = `<td>event time ${i + 1}</td><td>label ${
        i + 1
      }</td><td>cheese ${i + 1}</td><td>colour ${i + 1}</td><td>aspect ${
        i + 1
      }</td><td>when ${i + 1}</td><td> ${i * 10}</td><td>${i + 1}</td>`;
      return el;
    },
  };
}

function getProps(hook) {
  return {
    maxHeight: getAttributeOrThrow(hook.el, "data-max-height", parseInteger),
    follow: false, //getAttributeOrThrow(hook.el, "data-follow", parseBoolean),
    total: getAttributeOrThrow(hook.el, "data-total", parseInteger),
    lineHeight: getAttributeOrThrow(hook.el, "data-line-height", parseInteger),
    pageSize: getAttributeOrThrow(hook.el, "data-page-size", parseInteger),
    url: getAttributeOrThrow(hook.el, "data-url"),
  };
}

export default HyperlistLivebook;
