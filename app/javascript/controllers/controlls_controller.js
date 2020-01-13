import { Controller } from "stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  initialize() {
    this.cable = consumer.subscriptions.create( "ControllsChannel", {
      connected() {
        console.log("ControllsChannel Connected");
      },
      rejected() {
        console.log("ControllsChannel Rejected");
      },
      disconnected() {
        console.log("ControllsChannel Disconnected");
        document.location.href = "/";
      },
      received(data) {
        console.log("ControllsChannel " + data)
      }
    });
  }
}