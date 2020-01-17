import { Controller } from "stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static targets = ["scrollHeight"]
  oldPercent = 0;

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
    var scrollPos = event.target.scrollTop;
    var height = this.scrollHeightTarget.offsetHeight;
    var percent = parseInt(100 * scrollPos / height);
    percent = percent * -1 + 100
    if (this.oldPercent != percent) {
      console.log(percent)
      this.oldPercent = percent
    }
  }
}