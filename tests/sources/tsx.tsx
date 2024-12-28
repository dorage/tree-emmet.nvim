export const Child = () => {
  return <></>;
};

const Compose = { Child };

export const Element = () => {
  return (
    <>
      {/* inward test */}
      <div id="element_blank"></div>
      <div id="element_with_text_content">lorem ipsum</div>
      <div id="element_with_js_expr">{2}</div>
      <div id="element_self_closed" />
      <div id="element_nested">
        <div></div>
      </div>
      <Compose.Child id="component_with_text_content">asdf</Compose.Child>
      <Compose.Child id="component_with_js_expr">{123456789}</Compose.Child>
      <Compose.Child id="component_self_closed" />
    </>
  );
};
