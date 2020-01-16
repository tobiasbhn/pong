import { Controller } from "stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static targets = ["scrollHeight"]

  initialize() {
    this.cable = consumer.subscriptions.create( "InputChannel", {
      connected() {
        console.log("InputChannel Connected");
      },
      rejected() {
        console.log("InputChannel Rejected");
      },
      disconnected() {
        console.log("InputChannel Disconnected");
        document.location.href = "/";
      },
      received(data) {
        console.log("InputChannel " + data)
      }
    });
  }

  scroll(event) {
    // console.log("SCROLLED: ")
    // console.log(event)

    var scrollPos = event.target.scrollTop;
    var height = this.scrollHeightTarget.offsetHeight;
    var percent = parseInt(100 * scrollPos / height);
    console.log(percent)
  }
}