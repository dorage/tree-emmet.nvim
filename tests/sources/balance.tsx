export const Element = () => {
  return (
    <>
      <div id="element_blank"></div>
      <div id="element_with_text_content">lorem ipsum</div>
      <div id="element_with_js_expr">{2}</div>
      <div id="element_self_closed" />
      <div id="element_nested" class="make_new_line">
        1234
      </div>
      <div id="element_nested_multiple">
        1234
        <div></div>
        {1234}
        1234
      </div>
    </>
  );
};
