import WeexGrowingio from "../../js/src";

if (window.Weex) {
  Weex.install(WeexGrowingio);
} else if (window.weex) {
  weex.install(WeexGrowingio);
}