import { Controller } from "stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  initialize() {
    this.cable = consumer.subscriptions.create( "ConnectionChannel", {
      connected() {
        console.log("ConnectionChannel Connected");
      },
      rejected() {
        console.log("ConnectionChannel Rejected");
      },
      disconnected() {
        console.log("ConnectionChannel Disconnected");
        document.location.href = "/";
      },
      received(data) {
        console.log("ConnectionChannel " + data)
      }
    });
  }
}