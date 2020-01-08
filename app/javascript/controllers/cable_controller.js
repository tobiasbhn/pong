import { Controller } from "stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  initialize() {
    this.cable = consumer.subscriptions.create( "GameChannel", {
      connected() {
        console.log("Connected");
      },
      rejected() {
        console.log("Rejected");
      },
      disconnected() {
        console.log("Disconnected");
        document.location.href = "/";
      },
      received(data) {
        console.log(data)
      }
    });
  }
}