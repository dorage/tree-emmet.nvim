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
      <div id="element_self_closed" />
      <div id="element_nested">
        <div></div>
      </div>
      <div id="element_nested_multiple">
        lorem ipsum
        <div></div>
        {1}
        <div></div>
      </div>
    </>
  );
};
