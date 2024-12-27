export const Child = () => {
  return <></>;
};

const Compose = { Child };

export const Element = () => {
  return (
    <>
      <div className="asdf" id="asdf" onClick={() => {}}>
        asdf
      </div>
      <div>{1234}</div>
      <div />
      <div style={{ width: "10px" }}></div>
      <Compose.Child>asdf</Compose.Child>
      <Compose.Child />
    </>
  );
};
