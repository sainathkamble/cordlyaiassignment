import React, { useState } from 'react';

function Chatbot() {
  const [messages, setMessages] = useState([]);
  const [input, setInput] = useState('');

  const handleSend = async () => {
    if (input.trim() === '') return;

    const newMessages = [...messages, { sender: 'user', text: input }];
    setMessages(newMessages);

    try {
      const response = await fetch('http://localhost:5000/chat', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ prompt: input }),
      });

      if (!response.ok) {
        throw new Error('Network response was not ok');
      }

      const data = await response.json();
      setMessages([...newMessages, { sender: 'bot', text: data.response }]);
    } catch (error) {
      console.error('Error sending message:', error);
      setMessages([...newMessages, { sender: 'bot', text: 'Sorry, something went wrong.' }]);
    }

    setInput('');
  };

  return (
    <div style={{ display: 'flex', flexDirection: 'column', height: '400px', border: '1px solid #ccc', borderRadius: '5px', padding: '10px', fontFamily: 'Arial, sans-serif' }}>
      <div style={{ flexGrow: 1, overflowY: 'auto', marginBottom: '10px', paddingRight: '10px' }}>
        {messages.map((msg, index) => (
          <div key={index} style={{ marginBottom: '10px', textAlign: msg.sender === 'user' ? 'right' : 'left' }}>
            <span style={{ 
              backgroundColor: msg.sender === 'user' ? '#007bff' : '#f1f1f1', 
              color: msg.sender === 'user' ? 'white' : 'black',
              padding: '8px 12px', 
              borderRadius: '10px',
              display: 'inline-block',
              maxWidth: '70%',
            }}>
              {msg.text}
            </span>
          </div>
        ))}
      </div>
      <div style={{ display: 'flex' }}>
        <input
          type="text"
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyPress={(e) => e.key === 'Enter' && handleSend()}
          style={{ flexGrow: 1, padding: '10px', borderRadius: '5px', border: '1px solid #ccc', marginRight: '10px' }}
          placeholder="Type your message..."
        />
        <button onClick={handleSend} style={{ padding: '10px 15px', borderRadius: '5px', border: 'none', backgroundColor: '#007bff', color: 'white', cursor: 'pointer' }}>
          Send
        </button>
      </div>
    </div>
  );
}

export default Chatbot; 