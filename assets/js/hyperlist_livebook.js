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
    console.log('mounted')
    this.props = getProps(this);
    this.state = {
      // lineHeight: null,
      // templateElement: null,
      contentElement: null,
      virtualizedList: null,
      page: 1,
    };

    // this.state.lineHeight = getLineHeight(this.el);

    // this.state.templateElement = this.el.querySelector("[data-template]");

    // if (!this.state.templateElement) {
    //   throw new Error(
    //     "VirtualizedLines must have a child with data-template attribute"
    //   );
    // }

    this.state.contentElement = this.el.querySelector("[data-content]");

    // if (!this.state.templateElement) {
    //   throw new Error("VirtualizedLines must have a child with data-content");
    // }

    const config = hyperListConfig(
      // this.state.templateElement,
      this.props.maxHeight,
      this.props.lineHeight,
      this.props.total,
    );
    this.virtualizedList = new HyperList(this.state.contentElement, config);
  },

  updated() {
    console.log('updated');
    this.props = getProps(this);

    const config = hyperListConfig(
      // this.state.templateElement,
      this.props.maxHeight,
      this.props.lineHeight,
      this.props.total,
    );

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
  maxHeight, lineHeight, total) {
  // const numberOfLines = templateElement.childElementCount;
  //  const numberOfLines = 100;

  return {
    height: Math.min(maxHeight, lineHeight * total),
    total: total,
    itemHeight: lineHeight,
    generate: (index) => {
      console.log('generate', index)
      // Clone n-th child of the template container.
      const el = document.createElement('tr');
      el.innerHTML = `<td>event time ${index + 1}</td><td>label ${index + 1}</td><td>cheese ${index + 1}</td><td>colour ${index + 1}</td><td>aspect ${index + 1}</td><td>when ${index + 1}</td><td> ${index * 10}</td><td>${index + 1}</td>`;
      return el;
    },
  };
}

function getProps(hook) {
  return {
    maxHeight: getAttributeOrThrow(hook.el, "data-max-height", parseInteger),
    follow: false, //getAttributeOrThrow(hook.el, "data-follow", parseBoolean),
    total:  getAttributeOrThrow(hook.el, "data-total", parseInteger),
    lineHeight:  getAttributeOrThrow(hook.el, "data-line-height", parseInteger),
    pageSize:  getAttributeOrThrow(hook.el, "data-page-size", parseInteger),
  };
}

export default HyperlistLivebook;
