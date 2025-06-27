const { GoogleGenerativeAI } = require("@google/generative-ai");

// IMPORTANT: You need to configure your Google AI API Key in your cloud function's environment variables.
// Do NOT hardcode the key directly in the code.
const genAI = new GoogleGenerativeAI(process.env.GOOGLE_API_KEY);

// This is the main handler function for the cloud function.
exports.main = async (event, context) => {
    try {
        // 1. Get user input from the request body
        const { name, gender, province, subject, score } = JSON.parse(event.body);

        // 2. Select the AI model
        const model = genAI.getGenerativeModel({ model: "gemini-1.5-pro-latest" });

        // 3. Construct the same detailed prompt as before
        const prompt = `
            请你扮演一位顶尖的高考志愿规划专家。
            我的基本信息如下：
            - 姓名: ${name}
            - 性别: ${gender}
            - 所在省份: ${province}
            - 选科: ${subject}
            - 高考预估分数: ${score}分

            请为我生成一份专业、详尽、个性化的高考志愿填报智能分析报告。报告必须严格遵循以下JSON格式，不要在JSON前后添加任何多余的文字或解释。

            {
              "profile": { "name": "${name}", "gender": "${gender}", "province": "${province}", "subject": "${subject}", "score": ${score}, "summary": "一句话总结该考生的分数定位和核心优势..." },
              "strategy": { "title": "核心报考策略与方法论", "content": ["..."] },
              "recommendations": [ { "tier": "冲刺院校", "probability": "...", "schools": [ { "name": "...", "tags": ["..."], "analysis": "...", "recommended_majors": ["..."] } ] } ],
              "future_paths": [ { "title": "...", "description": "...", "majors": ["..."] } ]
            }
        `; // Note: The full prompt is the same as before, truncated here for brevity.

        // 4. Call the AI model and get the response
        const result = await model.generateContent(prompt);
        const response = await result.response;
        let text = response.text();
        
        // Clean up the response to ensure it's a valid JSON string
        text = text.replace(/^```json\s*/, '').replace(/\s*```$/, '');

        // 5. Return the AI's response to the frontend
        return {
            statusCode: 200,
            headers: { 
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*" // Allows requests from any origin
            },
            body: text,
        };
    } catch (error) {
        console.error('Error calling Google AI:', error);
        return {
            statusCode: 500,
            headers: { 
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*"
            },
            body: JSON.stringify({ error: '调用Google AI服务时出错，请检查后台日志。' }),
        };
    }
}; 