const A = { B: () => <div></div> };
export const Element = () => {
  return (
    <div>
      <A.B id="element_splitted"></A.B>
      <A.B
        id="element_splitted_multiline"
        onClick={() => {}}
        className="test asdfasdjfhasdlkjh"
      ></A.B>
      <A.B id="element_self_closed" />
      <A.B
        id="element_self_closed_multiline"
        onClick={() => {}}
        className="test asdfasdjfhasdlkjh"
      />
    </div>
  );
};
