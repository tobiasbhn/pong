import { Controller } from "stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  initialize() {
    this.cable = consumer.subscriptions.create( "GameChannel", {
      connected() {
        console.log("GameChannel Connected");
      },
      rejected() {
        console.log("GameChannel Rejected");
      },
      disconnected() {
        console.log("GameChannel Disconnected");
        document.location.href = "/";
      },
      received(data) {
        console.log("GameChannel " + data)
      }
    });
  }
}