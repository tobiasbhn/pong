import { Controller } from "stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
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
}